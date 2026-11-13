# app/services/follow_up_scheduler.rb
#
# Responsável por criar os follow-ups automáticos (day7, day30, day90) quando
# uma AdoptionRequest é finalizada. Chamado por AdoptionRequest#finalize_adoption
# (Plano_PetHelp.txt, item 4.1).

class FollowUpScheduler
  MILESTONE_DAYS = {
    "day7" => 7,
    "day30" => 30,
    "day90" => 90
  }.freeze

  def initialize(adoption_request)
    @adoption_request = adoption_request
  end

  def schedule_all
    MILESTONE_DAYS.map do |milestone, days|
      schedule_one(milestone, days)
    end
  end

  private

  attr_reader :adoption_request

  def schedule_one(milestone, days)
    FollowUp.find_or_create_by!(
      user: adoption_request.adopter,
      pet: adoption_request.pet,
      milestone: milestone
    ) do |follow_up|
      follow_up.status = "pending"
      follow_up.due_date = days.days.from_now.to_date
    end
  end
end
