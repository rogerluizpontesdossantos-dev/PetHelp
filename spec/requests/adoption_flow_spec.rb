require "rails_helper"

RSpec.describe "Fluxo completo de adoção", type: :request do
  it "solicita, aceita, assina o termo, conclui e agenda os follow-ups" do
    owner = create(:user)
    adopter = create(:user)
    pet = create(:pet, owner: owner)

    # 1. Adotante solicita adoção
    post "/api/v1/adoption_requests",
      params: { pet_id: pet.id, message: "Quero muito adotar!" },
      headers: auth_headers(adopter)
    expect(response).to have_http_status(:created)
    request_id = JSON.parse(response.body)["id"]

    # 2. Dono aceita
    post "/api/v1/adoption_requests/#{request_id}/accept", headers: auth_headers(owner)
    expect(response).to have_http_status(:ok)
    expect(pet.reload).to be_in_process

    # 3. Dono cria o termo
    post "/api/v1/adoption_terms",
      params: { adoption_request_id: request_id, content: "Termo de adoção do Rex." },
      headers: auth_headers(owner)
    expect(response).to have_http_status(:created)
    term_id = JSON.parse(response.body)["id"]

    # 4. Adotante assina o termo
    post "/api/v1/adoption_terms/#{term_id}/sign", headers: auth_headers(adopter)
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["signed"]).to eq(true)

    # 5. Dono conclui a adoção
    post "/api/v1/adoption_requests/#{request_id}/complete", headers: auth_headers(owner)
    expect(response).to have_http_status(:ok)

    adoption_request = AdoptionRequest.find(request_id)
    expect(adoption_request).to be_completed
    expect(pet.reload).to be_adopted
    expect(FollowUp.where(user: adopter, pet: pet).count).to eq(3)

    # 6. Adotante avalia o doador
    post "/api/v1/reviews",
      params: { adoption_request_id: request_id, rating: 5, comment: "Excelente experiência!" },
      headers: auth_headers(adopter)
    expect(response).to have_http_status(:created)

    expect(owner.reload.reputation_score.to_f).to eq(5.0)
    expect(owner.reviews_count).to eq(1)
  end
end
