require "rails_helper"

RSpec.describe Pet, type: :model do
  subject { build(:pet) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to belong_to(:owner).class_name("User") }

  describe "state machine" do
    it "começa disponível" do
      pet = create(:pet)
      expect(pet).to be_available
    end

    it "transita de available para in_process" do
      pet = create(:pet)
      pet.start_process!
      expect(pet).to be_in_process
    end

    it "transita direto de available para adopted" do
      pet = create(:pet)
      pet.mark_adopted!
      expect(pet).to be_adopted
    end

    it "não permite marcar como adotado se já adotado" do
      pet = create(:pet)
      pet.mark_adopted!
      expect { pet.mark_adopted! }.to raise_error(AASM::InvalidTransition)
    end
  end

  describe "scopes" do
    it ".available_for_adoption retorna apenas pets disponíveis" do
      available_pet = create(:pet)
      adopted_pet = create(:pet, status: "adopted")

      expect(Pet.available_for_adoption).to include(available_pet)
      expect(Pet.available_for_adoption).not_to include(adopted_pet)
    end

    it ".by_city filtra por cidade" do
      sp_pet = create(:pet, city: "São Paulo")
      rj_pet = create(:pet, city: "Rio de Janeiro")

      expect(Pet.by_city("São Paulo")).to include(sp_pet)
      expect(Pet.by_city("São Paulo")).not_to include(rj_pet)
    end
  end
end
