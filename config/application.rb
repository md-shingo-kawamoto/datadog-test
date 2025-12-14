require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TodoApp
  class Application < Rails::Application
    config.load_defaults 7.1
    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja
    
    # Datadog APM設定は config/initializers/datadog.rb で行う
  end
end

