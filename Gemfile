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
gem "aws-sdk-s3", require: false

gem 'bootstrap', '~> 4.1.3'
gem 'bourbon'

# TODO: remove once dev complete
if File.exist?('../datashift')
  gem 'datashift', path: '../datashift'
else
  gem 'datashift', git: 'https://github.com/autotelik/datashift.git'
end

if File.exists?('/home/rubyuser/SoftwareDev/git/datashift_audio_engine')
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

gem 'loofah', ">= 2.2.3"

gem 'pg', '~> 0.18'
gem 'pundit'

gem 'rails_sortable', '~> 1.2.1'
gem 'rubocop', '~> 0.57.2'
gem 'rubyzip', '~> 1.2.2'

gem 'select2-rails'
gem 'searchkick'
gem 'sidekiq'

gem 'therubyracer', platform: :ruby
gem 'tzinfo-data'

gem 'nokogiri', '1.8.2'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'

  # On Centos - QMAKE=/usr/lib64/qt5/bin/qmake gem install capybara-webkit
  #
  # TODO How to set in bundle - this dont seem to work :
  #   bundle config build.capybara-webkit  --with-opt-include=/usr/lib64/qt5/bin/qmake
  #
  gem 'capybara-webkit'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'

  gem "capistrano", "~> 3.11", require: false

  gem 'i18n-tasks', '~> 0.9.24'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'

  gem 'rails_layout'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner', platforms: [:mri]
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 3.1'
end
