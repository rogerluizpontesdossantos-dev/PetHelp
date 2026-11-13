require "rails_helper"

RSpec.describe AdoptionRequest, type: :model do
  describe "validações de negócio" do
    it "não permite que o dono do pet adote o próprio pet" do
      owner = create(:user)
      pet = create(:pet, owner: owner)
      request = build(:adoption_request, adopter: owner, pet: pet)

      expect(request).not_to be_valid
      expect(request.errors[:adopter]).to be_present
    end

    it "não permite solicitação para pet indisponível" do
      pet = create(:pet, status: "adopted")
      request = build(:adoption_request, pet: pet)

      expect(request).not_to be_valid
      expect(request.errors[:pet]).to be_present
    end

    it "não permite adotante inelegível (reputação baixa com histórico)" do
      adopter = create(:user, reputation_score: 1.0, reviews_count: 3)
      pet = create(:pet)
      request = build(:adoption_request, adopter: adopter, pet: pet)

      expect(request).not_to be_valid
      expect(request.errors[:adopter]).to be_present
    end
  end

  describe "fluxo completo de estados" do
    it "aceita a solicitação e move o pet para in_process" do
      request = create(:adoption_request)
      request.accept!

      expect(request).to be_accepted
      expect(request.pet).to be_in_process
    end

    it "rejeita a solicitação" do
      request = create(:adoption_request)
      request.reject!

      expect(request).to be_rejected
    end

    it "cancela uma solicitação aceita e libera o pet" do
      request = create(:adoption_request, :accepted)
      request.cancel!

      expect(request).to be_cancelled
      expect(request.pet.reload).to be_available
    end

    it "não permite concluir sem o termo assinado" do
      request = create(:adoption_request, :accepted)

      expect { request.complete! }.to raise_error(AASM::InvalidTransition)
    end

    it "conclui a adoção, marca o pet como adotado e agenda os follow-ups" do
      request = create(:adoption_request, :completed)

      expect(request).to be_completed
      expect(request.pet.reload).to be_adopted
      expect(FollowUp.where(user: request.adopter, pet: request.pet).count).to eq(3)
      expect(FollowUp.pluck(:milestone)).to match_array(%w[day7 day30 day90])
    end
  end
end
