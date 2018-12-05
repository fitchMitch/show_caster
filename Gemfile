source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Technical
# -----------------------
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
ruby '2.2.7'

gem 'rails',                                                '~> 5.0.6'
gem 'pg',                                                   '~> 0.20'
gem 'jbuilder',                                             '~> 2.5'
gem 'annotate'
gem 'coffee-rails',                                         '~> 4.2'
gem 'slim',                                                 '>= 3.0.9'
gem 'slim-rails',                                           '~> 3.1'
# Front gems
# -----------------------
gem 'jquery-rails',                                         '~> 4.3'
gem 'bootstrap-sass',                                       '~> 3.3'
#bootstrap 3 helper for navbar for example~>
gem 'bh',                                                   '~> 1.3'
gem 'sassc-rails',                                          '~> 1.3'
gem 'uglifier',                                             '>= 1.3.0'
gem 'modernizr-rails',                                      '~> 2.7'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'meta-tags', require: 'meta_tags'
gem 'font-awesome-rails',                                   '~> 4.7'
gem 'simple_form',                                          '~> 4.0'
gem 'enum_help',                                            '~> 0.0'
gem 'cocoon',                                               '~> 1.2'
gem 'papercrop',                                            '~> 0.3'
gem 'rails-assets-jcrop', source: 'https://rails-assets.org'
gem 'commontator',                                          '~> 5.1.0'
gem 'kaminari',                                             '~> 1.1'
# API ones
# -----------------------
gem 'gibbon',                                               '~> 3.2'
gem 'google-api-client',                                    '~> 0.23'
gem 'omniauth-google-oauth2',                               '~> 0.5'
# https://docs.bugsnag.com/platforms/ruby/rails/
gem 'bugsnag',                                              '~> 6.8'
# middleware
# -----------------------
gem 'pundit',                                               '~> 1.1'
gem 'paperclip',                                            '~> 6.0.0'
gem 'paperclip-i18n',                                       '~> 4.3'
gem 'mini_magick',                                          '~> 4.8'
#---------------------------

group :development, :test do
  gem 'puma',                                                 '~> 3.0'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug',                                               '~> 10.0'
  gem 'better_errors',                                        '~> 2.4'
  gem 'binding_of_caller',                                    '~> 0.8'
  gem 'pry',                                                  '~> 0.11'
  gem 'pry-byebug',                                           '~> 3.6'

  # %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
  #   gem lib, git: "https://github.com/rspec/#{lib}.git", branch: 'master'
  # end
  gem 'database_cleaner',                                       '~> 1.7'
  gem 'rails-controller-testing',                               '~> 1.0'
  gem 'shoulda-matchers',                                       '~> 3.1'
  gem 'ffaker',                                                 '~> 2.9'
  gem 'factory_bot_rails',                                      '~> 4.8'
end



group :development do
  gem 'web-console',                                            '>= 3.3.0'
  gem 'listen',                                                 '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring',                                                 '~> 2.0'
  gem 'spring-commands-rspec',                                  '~> 1.0.4'
  gem 'spring-watcher-listen',                                  '~> 2.0.0'
  gem 'letter_opener',                                          '~> 1.6'
end

group :test do
  gem 'simplecov', require: false
  # gem 'vcr'
  gem 'webmock',                                                '~> 3.4'
  gem 'capybara',                                               '~> 3.0'
  gem 'launchy',                                                '~> 2.4'
  gem 'selenium-webdriver',                                     '~> 3.11'
  gem 'chromedriver-helper'
  gem 'pundit-matchers',                                        '~> 1.4.1'
  gem 'rubocop-rspec',                                          '~> 1.28'
  gem 'rspec',                                                  '~> 3.7.0'
  gem 'rspec-collection_matchers'
  gem 'rspec-rails'
  gem 'rspec-retry'
  gem 'shoulda'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  gem 'lograge',    '~> 0.10'
  gem 'passenger', '5.1.12', require: 'phusion_passenger/rack_handler'
end
