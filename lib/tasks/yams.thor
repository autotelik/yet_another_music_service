# frozen_string_literal: true

begin
  require File.expand_path('config/environment.rb')
rescue StandardError => e
  puts("Failed to initialise ActiveRecord : #{e.message}\n#{e.backtrace}")
  raise "Failed to initialise ActiveRecord : #{e.message}"
end

YamsCore::Engine.load_thor_tasks
