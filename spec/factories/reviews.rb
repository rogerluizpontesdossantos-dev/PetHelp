FactoryBot.define do
  factory :review do
    association :adoption_request, :completed
    reviewer { adoption_request.adopter }
    reviewee { adoption_request.pet.owner }
    rating { 5 }
    comment { "Processo de adoção muito tranquilo." }
  end
end
