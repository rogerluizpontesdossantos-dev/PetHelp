class AdoptionRequest < ApplicationRecord
  include AASM

  belongs_to :adopter, class_name: "User", inverse_of: :adoption_requests
  belongs_to :pet
  has_one :adoption_term, dependent: :destroy

  validates :message, length: { maximum: 1000 }, allow_blank: true
  validate :adopter_is_not_owner
  validate :pet_is_available, on: :create
  validate :adopter_is_eligible, on: :create

  aasm column: :status do
    state :pending, initial: true
    state :accepted
    state :rejected
    state :cancelled
    state :completed

    event :accept do
      transitions from: :pending, to: :accepted, guard: :pet_still_available? do
        after do
          pet.start_process!
        end
      end
    end

    event :reject do
      transitions from: :pending, to: :rejected
    end

    event :cancel do
      transitions from: [:pending, :accepted], to: :cancelled do
        after do
          pet.cancel_process! if pet.in_process?
        end
      end
    end

    event :complete do
      transitions from: :accepted, to: :completed, guard: :term_signed? do
        after do
          finalize_adoption
        end
      end
    end
  end

  def finalize_adoption
    pet.mark_adopted!
    FollowUpScheduler.new(self).schedule_all
  end

  private

  def pet_still_available?
    pet.available? || pet.in_process?
  end

  def term_signed?
    adoption_term.present? && adoption_term.signed_at.present?
  end

  def adopter_is_not_owner
    return if pet.blank? || adopter.blank?

    errors.add(:adopter, "não pode adotar o próprio pet") if pet.owner_id == adopter_id
  end

  def pet_is_available
    return if pet.blank?

    errors.add(:pet, "não está disponível para adoção") unless pet.available?
  end

  def adopter_is_eligible
    return if adopter.blank?

    errors.add(:adopter, "não é elegível para adotar no momento") unless adopter.eligible_to_adopt?
  end
end
