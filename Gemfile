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
gem 'acts-as-taggable-on'
gem 'administrate'
gem 'autoprefixer-rails', '8.6.5'

gem 'bootstrap', '~> 4.1.2'
gem 'bourbon'

gem 'datashift_audio_engine', git: 'https://github.com/autotelik/datashift_audio_engine.git'
gem 'devise'
gem 'devise-jwt', '~> 0.5.7'          # Tokens
gem 'devise_invitable'                # An invitation strategy for devise
gem 'dotenv', '~> 2.5.0'
gem 'dotenv-rails', '~> 2.5.0', require: 'dotenv/rails-now'

gem 'elasticsearch-model', '~> 5.1.0' # major release should match the ES major release in docker compose
gem 'elasticsearch-rails', '~> 5.1.0'

gem 'font-awesome-rails'

gem 'high_voltage', '~> 3.1.0'

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'kaminari'

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
  gem 'capybara-webkit'

  # TODO: remove once dev complete
  if File.exist?('../datashift')
    gem 'datashift', path: '../datashift'
  else
    gem 'datashift', git: 'https://github.com/autotelik/datashift.git'
  end
end

group :development do
  gem 'binding_of_caller'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'

  gem 'i18n-tasks', '~> 0.9.24'
end

group :development do
  gem 'better_errors'
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
