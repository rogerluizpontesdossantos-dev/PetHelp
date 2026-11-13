class Review < ApplicationRecord
  belongs_to :reviewer, class_name: "User", inverse_of: :reviews_written
  belongs_to :reviewee, class_name: "User", inverse_of: :reviews_received
  belongs_to :adoption_request

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, length: { maximum: 500 }, allow_blank: true
  validates :reviewer_id, uniqueness: { scope: :adoption_request_id }
  validate :adoption_request_must_be_completed
  validate :reviewer_is_not_reviewee

  after_create_commit :update_reviewee_reputation

  private

  def adoption_request_must_be_completed
    return if adoption_request.blank?

    errors.add(:adoption_request, "precisa estar concluída para permitir avaliação") unless adoption_request.completed?
  end

  def reviewer_is_not_reviewee
    errors.add(:reviewee, "não pode avaliar a si mesmo") if reviewer_id == reviewee_id
  end

  def update_reviewee_reputation
    ReputationCalculator.new(reviewee).recalculate!
  end
end
