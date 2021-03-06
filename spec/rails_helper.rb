# https://www.devmynd.com/blog/setting-up-rspec-and-capybara-in-rails-5-for-testing/
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'webmock/rspec'
require 'capybara/rspec'
require 'selenium/webdriver'
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# ================================
# CAPYBARA
# ================================
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w(headless disable-gpu) }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end

# Capybara.javascript_driver = :chrome
Capybara.javascript_driver = :headless_chrome

# Capybara::Screenshot.register_driver :chrome do |driver, path|
#   driver.save_screenshot(path)
# end
# ================================

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root }/spec/fixtures"

  config.include Paperclip::Shoulda::Matchers

  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include AttributesMatcher, type: :request

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :feature

  config.include AttributesMatcher, type: :feature
  config.include ActiveJob::TestHelper, type: :feature
  config.include Selectors, type: :feature
  config.include MailerMacros, type: :feature
  config.include PollsHelper, type: :feature

  # show retry status in spec process
  config.verbose_retry = true
  # Try twice (retry once)
  config.default_retry_count = 2
  # Only retry when Selenium raises Net::ReadTimeout
  config.exceptions_to_retry = [Net::ReadTimeout]

  # config.include Capybara::DSL, file_path: "spec/requests"
  # BEFORE
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    FFaker::NameFR.unique.clear
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner.start
  end
  #AFTER
  config.after(:each) do
    DatabaseCleaner.clean
  end
  # Paperclip configuration
  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/test_files/"])
  end
end
