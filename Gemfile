# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '>= 2.5.0'

# RAILS
gem 'rails', '~> 5.2.1'

gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'

gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

# YAMS
#
gem 'active_storage_validations'
gem 'acts-as-taggable-on'
gem 'administrate'
gem 'autoprefixer-rails', '8.6.5'
gem 'aws-sdk-s3', require: false

gem 'bootstrap', '~> 4.1.3'
gem 'bourbon'

# TODO: remove once dev complete
if File.exist?('../datashift')
  gem 'datashift', path: '../datashift'
else
  gem 'datashift', git: 'https://github.com/autotelik/datashift.git'
end

if File.exist?('/home/rubyuser/SoftwareDev/git/datashift_audio_engine')
  gem 'datashift_audio_engine', path: '/home/rubyuser/SoftwareDev/git/datashift_audio_engine'
else
  gem 'datashift_audio_engine', git: 'https://github.com/autotelik/datashift_audio_engine.git'
end

gem 'devise'
gem 'devise-jwt', '~> 0.5.7'          # Tokens
gem 'devise_invitable'                # An invitation strategy for devise
gem 'dotenv', '~> 2.5.0'
gem 'dotenv-rails', '~> 2.5.0', require: 'dotenv/rails-now'

gem 'elasticsearch-model', '~> 5.1.0' # major release should match the ES major release in docker compose
gem 'elasticsearch-rails', '~> 5.1.0'

gem 'font-awesome-rails'

gem 'high_voltage', '~> 3.1.0'

gem 'image_processing', '~> 1.7'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'

gem 'loofah', '>= 2.2.3'

gem 'pg', '~> 0.18'
gem 'pundit'

gem 'rails_event_store', '~> 0.33'
gem 'rails_sortable', '~> 1.2.1'
gem 'rubocop', '~> 0.57.2'
gem 'rubyzip', '~> 1.2.2'

gem 'searchkick'
gem 'select2-rails'
gem 'sidekiq'

gem 'therubyracer', platform: :ruby
gem 'tzinfo-data'

if File.exist?('/home/rubyuser/SoftwareDev/git/yams_core')
  gem 'yams_core', path: '/home/rubyuser/SoftwareDev/git/yams_core'
else
  gem 'yams_core', git: 'https://github.com/autotelik/yams_core.git'
end

if File.exist?('/home/rubyuser/SoftwareDev/git/yams_events/')
  gem 'yams_events', path: '/home/rubyuser/SoftwareDev/git/yams_events'
else
  gem 'yams_events', git: 'https://github.com/autotelik/yams_events.git'
end

group :development, :test do
  gem 'byebug'

  gem 'capistrano'

  gem 'listen'

  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara', '~> 2.13'

  # On Centos - QMAKE=/usr/lib64/qt5/bin/qmake gem install capybara-webkit
  #
  # TODO How to set in bundle - this dont seem to work :
  #   bundle config build.capybara-webkit  --with-opt-include=/usr/lib64/qt5/bin/qmake
  #
  gem 'capybara-webkit'

  gem 'database_cleaner', platforms: [:mri]

  gem 'factory_bot_rails'
  gem 'faker'

  gem 'i18n-tasks', '~> 0.9.28'

  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 3.1'
end
