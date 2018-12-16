require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ShowCaster
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    # Don't generate system test files.
    config.generators.system_tests = nil

    # I18n
    config.i18n.load_path += Dir[Rails.root.join(
      'lib',
      'locale',
      '*.{ rb, yml }'
    )]
    config.i18n.load_path += Dir[Rails.root.join(
      'config',
      'locales',
      '**',
      '*.yml'
    )]
    # Whitelist locales available for the application
    config.i18n.available_locales = %i[en fr]
    config.i18n.default_locale = :fr

    config.time_zone = 'Paris'
    config.active_record.default_timezone = :local
    config.beginning_of_week = :monday

    config.autoload_paths += %W(#{config.root}/lib)

    config.active_job.queue_adapter = Rails.env.production? ? :sidekiq : :async
  end
end
