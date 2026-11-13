require "rails_helper"

RSpec.describe User, type: :model do
  describe "validações" do
    subject { build(:user) }

    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:cpf) }

    it "rejeita CPF com menos de 11 dígitos" do
      user = build(:user, cpf: "123456789")
      expect(user).not_to be_valid
      expect(user.errors[:cpf]).to be_present
    end

    it "rejeita CPF com dígitos verificadores inválidos" do
      user = build(:user, cpf: "11111111111")
      expect(user).not_to be_valid
      expect(user.errors[:cpf]).to include("inválido")
    end

    it "aceita CPF válido com pontuação e remove a formatação" do
      user = build(:user, cpf: "529.982.247-25")
      expect(user).to be_valid
      expect(user.cpf).to eq("52998224725")
    end
  end

  describe "#eligible_to_adopt?" do
    it "é elegível quando ainda não tem reviews" do
      user = build(:user, reputation_score: 0, reviews_count: 0)
      expect(user.eligible_to_adopt?).to be true
    end

    it "é elegível quando reputação está acima do mínimo" do
      user = build(:user, reputation_score: 3.5, reviews_count: 4)
      expect(user.eligible_to_adopt?).to be true
    end

    it "não é elegível quando reputação está abaixo do mínimo" do
      user = build(:user, reputation_score: 1.0, reviews_count: 4)
      expect(user.eligible_to_adopt?).to be false
    end
  end
end
