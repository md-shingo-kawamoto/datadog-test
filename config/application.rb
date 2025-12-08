require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TodoApp
  class Application < Rails::Application
    config.load_defaults 7.1
    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja
    
    # Datadog APM設定
    config.after_initialize do
      Datadog.configure do |c|
        c.tracing.enabled = true
        c.tracing.analytics_enabled = true
        c.tracing.instrument :rails
        c.tracing.instrument :mysql2
        c.env = ENV['DD_ENV'] || 'development'
        c.service = ENV['DD_SERVICE'] || 'todo-app'
        c.version = ENV['DD_VERSION'] || '1.0.0'
      end
    end
  end
end

