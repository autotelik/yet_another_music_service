# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '>= 2.6.0'

gem 'dotenv', '~> 2.5.0'
gem 'dotenv-rails', '~> 2.5.0', require: 'dotenv/rails-now'
require 'dotenv/load'

# TODO: remove once dev complete move to core gemspec
if File.exists?('../datashift_audio_engine')
  gem 'datashift_audio_engine', path: '../datashift_audio_engine'
else
  gem 'datashift_audio_engine', git: 'https://github.com/autotelik/datashift_audio_engine.git'
end

# TODO: remove once dev complete
if File.exist?('../datashift')
  gem 'datashift', path: '../datashift'
else
  gem 'datashift', git: 'https://github.com/autotelik/datashift.git', branch: 'master'
end

# RAILS
gem 'rails', '~> 5.2.1'
gem 'rack', '2.0.8'

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
gem 'aws-sdk-s3', require: false

# No API for Stores etc yet,
# but these are the Controller code = maybe can hack the UI form submissions
#
# https://github.com/btcpayserver/btcpayserver/tree/master/BTCPayServer/Controllers
# https://bitpay.com/api/#rest-api
gem 'bitpay-sdk', :git => 'https://github.com/btcpayserver/ruby-client'

gem 'bootstrap', '~> 4.4.1'
gem 'bourbon'

if ENV['YAMS_NON_OPEN_SOURCE_GEMS'].to_s.downcase == 'true'
  %w{ yams_events }.each do |lib|
    library_path = File.expand_path("../../#{lib}", __FILE__)
    if File.exist?(library_path) && ENV['YAMS_USE_LOCAL_PATHS'].to_s.downcase == 'true'
      gem lib, :path => library_path
    else
      gem lib, :git => "https://github.com/autotelik/#{lib}.git"#, :branch => branch
    end
  end
end

gem 'elasticsearch-model', '~> 5.1.0' # major release should match the ES major release in docker compose
gem 'elasticsearch-rails', '~> 5.1.0'

gem 'font-awesome-rails'

gem 'high_voltage', '~> 3.1.0'

gem 'image_processing', '~> 1.7'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'

gem 'listen'

gem 'pg', '~> 0.18'
gem 'pundit'

gem 'rails_sortable', '~> 1.2.1'
gem 'rubocop', '~> 0.57.2'

gem 'searchkick'
gem 'select2-rails'
gem 'sidekiq'

gem 'mini_racer'#, platform: :ruby
gem 'tzinfo-data'

#if File.exist?('../yams_core')
  gem 'yams_core', path: '../yams_core'
#else
#  gem 'yams_core', git: 'https://github.com/autotelik/yams_core.git'
#end

group :development do
  gem 'bullet'
end

group :development, :test do
  gem 'byebug'

  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'

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

  gem 'database_cleaner'

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
