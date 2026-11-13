class AdoptionRequestSerializer
  def initialize(adoption_request)
    @adoption_request = adoption_request
  end

  def as_json(*)
    {
      id: adoption_request.id,
      status: adoption_request.status,
      message: adoption_request.message,
      pet: { id: adoption_request.pet_id, name: adoption_request.pet.name },
      adopter: { id: adoption_request.adopter_id, name: adoption_request.adopter.name },
      adoption_term_id: adoption_request.adoption_term&.id,
      created_at: adoption_request.created_at
    }
  end

  private

  attr_reader :adoption_request
end
