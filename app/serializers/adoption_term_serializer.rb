class AdoptionTermSerializer
  def initialize(adoption_term)
    @adoption_term = adoption_term
  end

  def as_json(*)
    {
      id: adoption_term.id,
      adoption_request_id: adoption_term.adoption_request_id,
      content: adoption_term.content,
      signed: adoption_term.signed?,
      signed_at: adoption_term.signed_at
    }
  end

  private

  attr_reader :adoption_term
end
