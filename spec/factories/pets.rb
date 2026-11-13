FactoryBot.define do
  factory :pet do
    association :owner, factory: :user
    sequence(:name) { |n| "Pet #{n}" }
    species { "dog" }
    size { "medium" }
    description { "Pet dócil e sociável." }
    city { "São Paulo" }
    state { "SP" }
    vaccination_status { true }
  end
end
