Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false

  config.active_storage.service = :amazon

  config.log_level = :info
  config.log_tags = [:request_id]

  config.force_ssl = true

  config.active_job.queue_adapter = :sidekiq

  config.action_controller.perform_caching = true
  config.cache_store = :redis_cache_store, { url: ENV["REDIS_URL"] }
end
