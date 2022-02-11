source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'dotenv', '~> 2.7.5'
gem 'dotenv-rails', '~> 2.7.5', require: 'dotenv/rails-now'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.4.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
#gem 'webpacker', '~> 5.0'
gem 'webpacker', '~> 5.x'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

# YAMS
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
gem 'ed25519', '>= 1.2', '< 2.0'

gem 'bootstrap'

gem 'high_voltage'                    # https://github.com/thoughtbot/high_voltage
gem 'hotwire-rails'                   # https://github.com/hotwired/hotwire-rails

gem "image_processing", ">= 1.2"      # https://edgeguides.rubyonrails.org/active_storage_overview.html

gem 'pagy', '~> 3.5'

gem 'stimulus-rails'

# TODO: remove once dev complete resolved_path

# bundle config local.datashift /home/rubyuser/SoftwareDev/git/datashift
gem 'datashift', git: 'https://github.com/autotelik/datashift.git', branch: "master"

# bundle config local.yams_core /home/rubyuser/SoftwareDev/git/yams_core
gem 'yams_core', git: 'https://github.com/autotelik/yams_core.git', branch: "master"

# bundle config local.yams_audio /home/rubyuser/SoftwareDev/git/yams_audio_engine
gem 'yams_audio', git: 'https://github.com/autotelik/yams_audio_engine.git', branch: "master"


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'database_cleaner'

  gem 'faker'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
