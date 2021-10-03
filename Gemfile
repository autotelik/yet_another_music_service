source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.4.1'

# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# YAMS
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
gem 'ed25519', '>= 1.2', '< 2.0'

gem 'bootstrap'

gem 'dotenv'
gem 'dotenv-rails', require: 'dotenv/rails-now'

gem 'high_voltage'                    # https://github.com/thoughtbot/high_voltage

gem 'hotwire-rails'                   # https://github.com/hotwired/hotwire-rails

gem 'pagy', '~> 3.5'

gem 'rswag-api'                       # https://github.com/rswag/rswag
gem 'rswag-ui'

# TODO: remove once dev complete resolved_path

# bundle config local.datashift /home/rubyuser/SoftwareDev/git/datashift
gem 'datashift', git: 'https://github.com/autotelik/datashift.git', branch: 'master'

# bundle config local.yams_core /home/rubyuser/SoftwareDev/git/yams_core
gem 'yams_core', git: 'https://github.com/autotelik/yams_core.git', branch: 'master'

# bundle config local.yams_audio /home/rubyuser/SoftwareDev/git/yams_audio_engine
gem 'yams_audio', git: 'https://github.com/autotelik/yams_audio_engine.git', branch: 'master'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'capistrano', '~> 3.14', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'rubocop'
  gem 'rubocop-rails'

  gem 'capistrano-locally', require: false
  gem 'capistrano-rails', '~> 1.6', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'rails-controller-testing'
  gem 'ruby_event_store-rspec'

  gem 'rspec'
  gem 'rspec-rails'
  gem 'rswag-specs'

  gem 'shoulda-matchers', '~> 4.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
