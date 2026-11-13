FactoryBot.define do
  factory :follow_up do
    association :user
    association :pet
    milestone { "day7" }
    status { "pending" }
    due_date { 7.days.from_now.to_date }
  end
end
