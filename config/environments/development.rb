Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true

  config.active_storage.service = :local

  config.action_controller.raise_on_missing_callback_actions = true

  config.active_job.queue_adapter = :sidekiq

  config.log_level = :debug
end
