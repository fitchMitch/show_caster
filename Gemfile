source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.6'
gem 'pg', '~> 0.20'
gem 'bootstrap-sass'
gem 'bh' #bootstrap helper for navbar for example
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'modernizr-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'jquery-rails'
gem 'meta-tags', require: 'meta_tags'
gem 'jbuilder', '~> 2.5'
gem 'simple_form'
gem "font-awesome-rails"
gem 'gibbon'
gem 'slim'
gem 'enum_help'
gem 'annotate'
gem 'pundit'
gem 'cocoon'

gem 'google-api-client', '~> 0.11'
gem 'omniauth-google-oauth2'
#---------------------------
# gem 'httplog', group: :development going with the following:
# HttpLog.options[:logger] = Rails.logger if Rails.env.development?
#---------------------------

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'puma', '~> 3.0'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry'
  gem 'pry-byebug'
  gem "slim-rails"

  # gem 'rspec', '~> 3.7.0'
  # gem 'rspec-rails'
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, :git => "https://github.com/rspec/#{lib}.git", :branch => 'master'
  end
  gem "database_cleaner"
  gem 'rails-controller-testing'
  gem 'shoulda-matchers'

  gem 'ffaker'
  gem 'factory_bot_rails'

  gem 'simplecov', require: false

end



group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem "capybara"
  gem "launchy"
  gem "selenium-webdriver"
  gem 'pundit-matchers', '~> 1.4.1'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  gem 'lograge'
  gem "passenger", "5.1.12", require: "phusion_passenger/rack_handler"
end
