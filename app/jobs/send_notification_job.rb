# app/jobs/send_notification_job.rb
#
# Job assíncrono para envio de notificações (email/push). O envio real
# (ActionMailer/serviço de push) é um item do roadmap (item 5.3 do plano);
# aqui fica o esqueleto assíncrono já integrado ao Sidekiq.

class SendNotificationJob
  include Sidekiq::Job

  sidekiq_options queue: "notifications", retry: 5

  # kind: símbolo identificando o tipo de notificação
  #   :adoption_request_received, :adoption_request_accepted,
  #   :follow_up_due, :review_received
  def perform(user_id, kind, payload = {})
    user = User.find_by(id: user_id)
    return unless user

    Rails.logger.info("[SendNotificationJob] kind=#{kind} user=#{user.id} payload=#{payload}")

    # TODO: integrar com ActionMailer/serviço de push quando disponível.
    # NotificationMailer.with(user: user, payload: payload).public_send(kind).deliver_later
  end
end
