class FollowUp < ApplicationRecord
  belongs_to :user
  belongs_to :pet

  MILESTONES = %w[day7 day30 day90].freeze
  STATUSES = %w[pending answered overdue].freeze

  validates :milestone, presence: true, inclusion: { in: MILESTONES }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :due_date, presence: true
  validates :well_being_rating, inclusion: { in: 1..5 }, allow_nil: true
  validates :pet_id, uniqueness: { scope: [:user_id, :milestone] }

  scope :pending, -> { where(status: "pending") }
  scope :overdue, -> { where(status: "overdue") }
  scope :due_before, ->(date) { where("due_date < ?", date) }

  def answer!(well_being_rating:, notes: nil)
    update!(
      status: "answered",
      answered_at: Time.current,
      well_being_rating: well_being_rating,
      notes: notes
    )
  end

  def mark_overdue!
    return unless status == "pending" && due_date < Date.current

    update!(status: "overdue")
  end
end
