# app/services/reputation_calculator.rb
#
# Recalcula a reputação (média das reviews recebidas) de um usuário.
# Chamado após cada Review criada (sistema de reputação bidirecional).

class ReputationCalculator
  def initialize(user)
    @user = user
  end

  def recalculate!
    reviews = user.reviews_received

    average = reviews.average(:rating)&.round(2) || 0.0

    user.update_columns(
      reputation_score: average,
      reviews_count: reviews.count
    )
  end

  private

  attr_reader :user
end
