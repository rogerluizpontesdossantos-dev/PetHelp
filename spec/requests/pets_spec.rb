require "rails_helper"

RSpec.describe "Api::V1::Pets", type: :request do
  describe "GET /api/v1/pets" do
    it "lista apenas pets disponíveis" do
      create(:pet)
      create(:pet, status: "adopted")

      get "/api/v1/pets"

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["pets"].size).to eq(1)
    end

    it "filtra por cidade" do
      create(:pet, city: "São Paulo")
      create(:pet, city: "Curitiba")

      get "/api/v1/pets", params: { city: "Curitiba" }

      body = JSON.parse(response.body)
      expect(body["pets"].size).to eq(1)
      expect(body["pets"].first["city"]).to eq("Curitiba")
    end
  end

  describe "POST /api/v1/pets" do
    it "requer autenticação" do
      post "/api/v1/pets", params: { name: "Rex", species: "dog", size: "medium", city: "SP", state: "SP" }
      expect(response).to have_http_status(:unauthorized)
    end

    it "cria um pet para o usuário autenticado" do
      user = create(:user)

      post "/api/v1/pets",
        params: { name: "Rex", species: "dog", size: "medium", city: "SP", state: "SP" },
        headers: auth_headers(user)

      expect(response).to have_http_status(:created)
      expect(Pet.last.owner_id).to eq(user.id)
    end
  end

  describe "POST /api/v1/pets/:id/mark_adopted" do
    it "permite apenas ao dono marcar como adotado" do
      owner = create(:user)
      other_user = create(:user)
      pet = create(:pet, owner: owner)

      post "/api/v1/pets/#{pet.id}/mark_adopted", headers: auth_headers(other_user)
      expect(response).to have_http_status(:forbidden)

      post "/api/v1/pets/#{pet.id}/mark_adopted", headers: auth_headers(owner)
      expect(response).to have_http_status(:ok)
      expect(pet.reload).to be_adopted
    end
  end
end
