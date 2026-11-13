class FollowUpSerializer
  def initialize(follow_up)
    @follow_up = follow_up
  end

  def as_json(*)
    {
      id: follow_up.id,
      milestone: follow_up.milestone,
      status: follow_up.status,
      due_date: follow_up.due_date,
      answered_at: follow_up.answered_at,
      well_being_rating: follow_up.well_being_rating,
      notes: follow_up.notes,
      pet: { id: follow_up.pet_id, name: follow_up.pet.name }
    }
  end

  private

  attr_reader :follow_up
end
