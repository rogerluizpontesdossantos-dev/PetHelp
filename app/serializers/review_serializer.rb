class ReviewSerializer
  def initialize(review)
    @review = review
  end

  def as_json(*)
    {
      id: review.id,
      rating: review.rating,
      comment: review.comment,
      reviewer: { id: review.reviewer_id, name: review.reviewer.name },
      reviewee: { id: review.reviewee_id, name: review.reviewee.name },
      adoption_request_id: review.adoption_request_id,
      created_at: review.created_at
    }
  end

  private

  attr_reader :review
end
