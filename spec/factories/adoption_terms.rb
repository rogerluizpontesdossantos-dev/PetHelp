FactoryBot.define do
  factory :adoption_term do
    association :adoption_request, :accepted
    content { "Termo de responsabilidade de adoção." }
  end
end
