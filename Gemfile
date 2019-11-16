# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# Technical
# -----------------------
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
ruby '2.4.1'

gem 'annotate'
gem 'coffee-rails', '~> 4.2', '>= 4.2.2'
gem 'jbuilder',                                             '~> 2.5'
gem 'pg',                                                   '~> 0.20'
gem 'rails', '~> 5.0.7', '>= 5.0.7.2'
gem 'slim',                                                 '>= 3.0.9'
gem 'slim-rails', '~> 3.2', '>= 3.2.0'
# Front gems
# -----------------------
gem 'bootstrap-sass',                                       '~> 3.3'
gem 'jquery-rails', '~> 4.3', '>= 4.3.5'
# bootstrap 3 helper for navbar for example~>
gem 'bh', '~> 1.3', '>= 1.3.6'
gem 'modernizr-rails',                                      '~> 2.7'
gem 'sassc-rails', '~> 1.3', '>= 1.3.0'
gem 'uglifier',                                             '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'acts-as-taggable-on',                                  '~> 6.0'
gem 'cocoon',                                               '~> 1.2'
gem 'commontator', '~> 5.1.0'
gem 'enum_help',                                            '~> 0.0'
gem 'font-awesome-rails', '~> 4.7', '>= 4.7.0.5'
gem 'kaminari', '~> 1.1', '>= 1.1.1'
gem 'meta-tags', '2.11.1'
gem 'papercrop', '~> 0.3', '>= 0.3.0'
gem 'rails-assets-jcrop', source: 'https://rails-assets.org'
gem 'rails-settings-cached', '~> 0.7', '>= 0.7.2'
gem 'ransack', '~> 2.1', '>= 2.1.1'
gem 'select2-rails',                                        '~> 4.0'
gem 'simple_form', '~> 5.0', '>= 5.0.0'
# gem 'rails-settings-cached', source: 'https://rubygems.org'
# API ones
# -----------------------
gem 'gibbon',                                               '~> 3.2'
gem 'google-api-client',                                    '~> 0.23'
gem 'omniauth-google-oauth2',                               '~> 0.5'
# https://docs.bugsnag.com/platforms/ruby/rails/
gem 'bugsnag',                                              '~> 6.8'
# middleware
# -----------------------
# background jogs
gem 'sidekiq',                                              '~> 5.2'
# -----------------------
gem 'mini_magick',                                          '~> 4.9'
gem 'paperclip',                                            '~> 6.0.0'
gem 'paperclip-i18n',                                       '~> 4.3'
gem 'pundit',                                               '~> 1.1'
#---------------------------

group :development, :test do
  gem 'puma',                                                 '~> 3.0'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'better_errors',                                        '~> 2.4'
  gem 'binding_of_caller',                                    '~> 0.8'
  gem 'byebug',                                               '~> 10.0'
  gem 'pry',                                                  '~> 0.11'
  gem 'pry-byebug',                                           '~> 3.6'

  # %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
  #   gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'master'
  # end
  gem 'database_cleaner',                                       '~> 1.7'
  gem 'factory_bot_rails', '~> 4.11', '>= 4.11.1'
  gem 'ffaker',                                                 '~> 2.9'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.4'
  gem 'shoulda-matchers',                                       '~> 3.1'
end

group :development do
  gem 'listen',                                                 '~> 3.0.5'
  gem 'web-console', '>= 3.7.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'letter_opener',                                          '~> 1.6'
  gem 'spring',                                                 '~> 2.0'
  gem 'spring-commands-rspec',                                  '~> 1.0.4'
  gem 'spring-watcher-listen',                                  '~> 2.0.0'
end

group :test do
  gem 'hashdiff',                                               ['>= 1.0.0.beta1', '< 2.0.0']
  gem 'simplecov', require: false
  # gem 'vcr'
  gem 'capybara', '~> 3.25', '>= 3.25.0'
  gem 'launchy',                                                '~> 2.4'
  gem 'pundit-matchers', '~> 1.4.1'
  gem 'rspec',                                                  '~> 3.7.0'
  gem 'rspec-collection_matchers'
  gem 'rspec-rails', '>= 3.7.2'
  gem 'rspec-retry'
  gem 'rubocop-rspec', '~> 1.28'
  gem 'shoulda'
  gem 'webdrivers', '~> 4.1', '>= 4.1.0'
  gem 'webmock', '~> 3.6'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  gem 'lograge', '~> 0.11', '>= 0.11.2'
  gem 'passenger', '5.1.12', require: 'phusion_passenger/rack_handler'
end
