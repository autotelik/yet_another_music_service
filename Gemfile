source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'dotenv', '~> 2.7.5'
gem 'dotenv-rails', '~> 2.7.5', require: 'dotenv/rails-now'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'

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

gem 'high_voltage'
gem 'importmap-rails'

# N.B README install did not work fully - To get stimulus to work I had to run manually
# rails webpacker:install:stimulus
gem 'hotwire-rails'

# TODO: remove once dev completeresolved_path

if File.exist?('/home/rubyuser/SoftwareDev/git/datashift')
  gem 'datashift', path: '../datashift'
else
  gem 'datashift', git: 'https://github.com/autotelik/datashift.git', branch: 'update-to-support-rails-6'
end

# gem 'yams_core', git: 'https://github.com/autotelik/yams_core.git'

if File.exist?('/home/rubyuser/SoftwareDev/git/yams_core')
  gem 'yams_core', path: '../yams_core'
else
  gem 'yams_core', git: 'https://github.com/autotelik/yams_core.git'
end

# TODO: remove once dev complete move to core gemspec
if File.exist?('/home/rubyuser/SoftwareDev/git/yams_audio_engine')
  gem 'yams_audio', path: '/home/rubyuser/SoftwareDev/git/yams_audio_engine'
else
  gem 'yams_audio', git: 'https://github.com/autotelik/yams_audio_engine.git'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

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
