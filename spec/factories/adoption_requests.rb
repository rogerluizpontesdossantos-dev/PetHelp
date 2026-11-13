FactoryBot.define do
  factory :adoption_request do
    association :adopter, factory: :user
    association :pet
    message { "Gostaria muito de adotar este pet." }

    trait :accepted do
      after(:create, &:accept!)
    end

    trait :completed do
      after(:create) do |adoption_request|
        adoption_request.accept!
        term = adoption_request.create_adoption_term!(content: "Termo de adoção padrão.")
        term.sign
        adoption_request.complete!
      end
    end
  end
end
