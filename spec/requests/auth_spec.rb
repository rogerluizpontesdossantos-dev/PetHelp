require "rails_helper"

RSpec.describe "Api::V1::Auth", type: :request do
  describe "POST /api/v1/auth/register" do
    it "cria um usuário e retorna um token" do
      post "/api/v1/auth/register", params: {
        name: "Ana Lima",
        email: "ana@example.com",
        cpf: "96432617003",
        phone: "11977776666",
        password: "senha123456",
        password_confirmation: "senha123456"
      }

      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["token"]).to be_present
      expect(body["user"]["email"]).to eq("ana@example.com")
    end

    it "retorna erro para CPF inválido" do
      post "/api/v1/auth/register", params: {
        name: "Ana Lima", email: "ana2@example.com", cpf: "11111111111",
        phone: "11977776666", password: "senha123456", password_confirmation: "senha123456"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "POST /api/v1/auth/login" do
    it "autentica com credenciais válidas" do
      user = create(:user, email: "login@example.com", password: "senha123456")

      post "/api/v1/auth/login", params: { email: "login@example.com", password: "senha123456" }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["token"]).to be_present
      expect(body["user"]["id"]).to eq(user.id)
    end

    it "rejeita senha incorreta" do
      create(:user, email: "login2@example.com", password: "senha123456")

      post "/api/v1/auth/login", params: { email: "login2@example.com", password: "errada" }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
