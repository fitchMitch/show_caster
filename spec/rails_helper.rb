# https://www.devmynd.com/blog/setting-up-rspec-and-capybara-in-rails-5-for-testing/
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'webmock/rspec'
require 'capybara/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

WebMock.disable_net_connect!(allow_localhost: true)

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.javascript_driver = :selenium_chrome

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# VCR.configure do |c|
#   c.cassette_library_dir  = Rails.root.join("spec", "vcr")
#   c.hook_into :webmock
# end


RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include Paperclip::Shoulda::Matchers

  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include OmniauthMacros
  config.include Sessions::LoginHelper, type: :controller

  config.include Requests::LoginHelper, type: :request
  config.include Requests::Loging, type: :request

  config.include Selectors, type: :feature
  config.include Features::SessionHelpers, type: :feature
  config.include MailerMacros, type: :feature
  config.include SessionsHelper, type: :feature
  config.include PollsHelper, type: :feature

  # config.include Capybara::DSL, :file_path => "spec/requests"
  # BEFORE
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
  config.before(:each) do
    # FFaker::UniqueGenerator.clear
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
