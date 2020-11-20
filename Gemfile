# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '>= 2.7.2'

gem 'dotenv', '~> 2.7.5'
gem 'dotenv-rails', '~> 2.7.5', require: 'dotenv/rails-now'


# TODO: remove once dev complete move to core gemspec
if File.exist?('../yams_audio_engine')
  gem 'yams_audio_engine', path: '../yams_audio_engine'
else
  gem 'yams_audio_engine', git: 'https://github.com/autotelik/yams_audio_engine.git'
end

# TODO: remove once dev complete
if File.exist?('../datashift')
  gem 'datashift', path: '../datashift'
else
  gem 'datashift', git: 'https://github.com/autotelik/datashift.git', branch: 'update-to-support-rails-6'
end

# RAILS
gem 'rack', '2.0.8'
gem 'rails', '~> 6.0.3.4', '>= 6.0.2.2'

gem 'jbuilder', '~> 2.5'

gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# YAMS
#
gem 'active_storage_validations'
gem 'acts-as-taggable-on'
gem 'administrate'
gem 'aws-sdk-s3', require: false


gem 'bootstrap', '~> 4.4.1'
gem 'bourbon'

if ENV['YAMS_NON_OPEN_SOURCE_GEMS'].to_s.downcase == 'true'
  %w[yams_events].each do |lib|
    library_path = File.expand_path("../../#{lib}", __FILE__)
    if File.exist?(library_path) && ENV['YAMS_USE_LOCAL_PATHS'].to_s.downcase == 'true'
      gem lib, path: library_path
    else
      gem lib, git: "https://github.com/autotelik/#{lib}.git" # , :branch => branch
    end
  end
end

gem 'elasticsearch-model', '~> 5.1.0' # major release should match the ES major release in docker compose
gem 'elasticsearch-rails', '~> 5.1.0'

gem 'high_voltage', '~> 3.1.0'

gem 'image_processing', '~> 1.7'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'kaminari', '>= 1.2.1'

gem 'listen'

gem 'pg', '~> 0.18'

# Use Puma as the app server
gem 'puma', '~> 4.1'
gem 'pundit'

gem 'rubocop', '~> 0.79.0'

gem 'searchkick'
gem 'select2-rails'
gem 'sidekiq'

gem 'mini_racer' # , platform: :ruby
gem 'tzinfo-data'

gem 'webpacker'

if File.exist?('../yams_core')
  gem 'yams_core', path: '../yams_core'
else
  gem 'yams_core', git: 'https://github.com/autotelik/yams_core.git'
end

group :development do
  gem 'bullet'
end

group :development, :test do
  gem 'byebug'

  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  gem "capistrano-scm-copy"

  gem 'database_cleaner'

  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara', '~> 2.13'
  gem 'capybara-email'

  # On Centos - QMAKE=/usr/lib64/qt5/bin/qmake gem install capybara-webkit
  #
  # TODO How to set in bundle - this dont seem to work :
  #   bundle config build.capybara-webkit  --with-opt-include=/usr/lib64/qt5/bin/qmake
  #
  gem 'capybara-webkit'

  gem 'factory_bot_rails'
  gem 'faker'

  gem 'i18n-tasks', '~> 0.9.28'

  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rails_event_store-rspec'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 3.1'
end
