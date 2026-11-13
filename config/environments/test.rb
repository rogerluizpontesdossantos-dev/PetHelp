Rails.application.configure do
  config.cache_classes = true
  config.eager_load = ENV["CI"].present?
  config.consider_all_requests_local = true

  config.active_storage.service = :test

  config.action_controller.perform_caching = false

  config.active_job.queue_adapter = :test

  config.log_level = :warn
end
