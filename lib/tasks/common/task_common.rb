# frozen_string_literal: true

module TaskCommon

  def docker_up(env)
    cli = "docker-compose -f docker-compose.yml -f docker/services/#{env}.yml up --no-recreate -d #{env}"
    puts "Running": cli
    system cli
  end

  # Helper to request a user enter a Rails env on cmd line.
  # Checks if valid env entered (based on config/database.yaml) and if acceptable to client script.
  #
  # accepted : Array of symbols representing environments against which current task can be run
  #
  def gets_rails_env(message, accepted)
    config = ImportConfig.new.rails_db_config
    puts "#{message} (#{accepted.join(' / ')})"
    found = false
    until found
      env = begin
              gets.chomp.strip.to_sym
            rescue StandardError
              nil
            end
      found = env && config[env]
      unless found
        puts "Error: Database config for environment '#{env}' not found, try again"
        next
      end
      unless env.intern.in?(accepted)
        puts "Error: Not authorised to run task against environment '#{env}', try again"
        found = false
      end
    end

    env
  end

  def load_rails_environment
    raise 'No config/environment.rb found - cannot initialise ActiveRecord' unless File.exist?(File.expand_path('config/environment.rb'))

    begin
      require File.expand_path('config/environment.rb')

      # Odd rails 4 does not autoload these - hopefully can be removed in Rails 5
      ['app/services'].each do |dir|
        Dir.glob(File.join(Rails.root, dir, '**/*.rb')).each { |c| require_dependency(c) }
      end
    rescue StandardError => e
      puts("Failed to initialise ActiveRecord : #{e.message}\n#{e.backtrace}")
      raise "Failed to initialise ActiveRecord : #{e.message}"
    end
  end

end
