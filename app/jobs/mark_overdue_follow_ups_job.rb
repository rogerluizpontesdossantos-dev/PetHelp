# app/jobs/mark_overdue_follow_ups_job.rb
#
# Job diário (agendado em config/sidekiq.yml via sidekiq-scheduler) que marca
# como "overdue" todo follow-up pendente cuja due_date já passou.

class MarkOverdueFollowUpsJob
  include Sidekiq::Job

  sidekiq_options queue: "follow_ups", retry: 3

  def perform
    FollowUp.pending.due_before(Date.current).find_each(&:mark_overdue!)
  end
end
