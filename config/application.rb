require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"

Bundler.require(*Rails.groups)

module Pethelp
  class Application < Rails::Application
    config.load_defaults 7.1

    config.api_only = true

    config.time_zone = "America/Sao_Paulo"
    config.active_record.default_timezone = :local

    config.autoload_paths << Rails.root.join("app/lib")
    config.autoload_paths << Rails.root.join("app/serializers")
  end
end
