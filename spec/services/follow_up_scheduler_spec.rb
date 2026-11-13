require "rails_helper"

RSpec.describe FollowUpScheduler do
  describe "#schedule_all" do
    it "cria os três follow-ups (day7, day30, day90) com as datas corretas" do
      request = create(:adoption_request, :accepted)
      travel_to Time.zone.local(2026, 1, 1) do
        described_class.new(request).schedule_all
      end

      follow_ups = FollowUp.where(user: request.adopter, pet: request.pet).order(:due_date)
      expect(follow_ups.pluck(:milestone)).to eq(%w[day7 day30 day90])
      expect(follow_ups.map(&:due_date)).to eq([
        Date.new(2026, 1, 8),
        Date.new(2026, 1, 31),
        Date.new(2026, 4, 1)
      ])
    end

    it "não duplica follow-ups se chamado mais de uma vez" do
      request = create(:adoption_request, :accepted)
      2.times { described_class.new(request).schedule_all }

      expect(FollowUp.where(user: request.adopter, pet: request.pet).count).to eq(3)
    end
  end
end
