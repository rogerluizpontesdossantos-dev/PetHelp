class Pet < ApplicationRecord
  include AASM

  belongs_to :owner, class_name: "User", inverse_of: :pets
  has_many :adoption_requests, dependent: :destroy
  has_many :follow_ups, dependent: :destroy
  has_one_attached :photo

  enum :species, { dog: 0, cat: 1, other: 2 }, prefix: :species
  enum :size, { small: 0, medium: 1, large: 2 }, prefix: :size

  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :species, presence: true
  validates :size, presence: true
  validates :photo, content_type: ["image/png", "image/jpeg", "image/webp"],
            size: { less_than: 5.megabytes }, if: -> { photo.attached? }

  scope :available_for_adoption, -> { where(status: "available") }
  scope :by_city, ->(city) { where(city: city) if city.present? }
  scope :by_species, ->(species) { where(species: species) if species.present? }

  aasm column: :status do
    state :available, initial: true
    state :in_process
    state :adopted
    state :unavailable

    event :start_process do
      transitions from: :available, to: :in_process
    end

    event :mark_adopted do
      transitions from: [:available, :in_process], to: :adopted
    end

    event :cancel_process do
      transitions from: :in_process, to: :available
    end

    event :make_unavailable do
      transitions from: [:available, :in_process], to: :unavailable
    end

    event :make_available do
      transitions from: [:unavailable, :in_process], to: :available
    end
  end
end
