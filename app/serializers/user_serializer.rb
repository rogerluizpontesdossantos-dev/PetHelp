class UserSerializer
  def initialize(user)
    @user = user
  end

  def as_json(*)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      reputation_score: user.reputation_score,
      reviews_count: user.reviews_count,
      created_at: user.created_at
    }
  end

  private

  attr_reader :user
end
