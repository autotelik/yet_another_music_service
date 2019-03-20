# frozen_string_literal: true

module TaskCommon

  def docker_up(container)
    file = File.join(Rails.root, 'docker-compose.yml')

    cli = "docker-compose -f #{file} -p yams_fm up --no-recreate -d #{container}"
    puts "Running": cli
    system cli
  end

  def docker_exec(cmd:, container: 'development')
    cli = "docker exec -ti #{container} #{cmd}"
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
    rescue StandardError => e
      puts("Failed to initialise ActiveRecord : #{e.message}\n#{e.backtrace}")
      raise "Failed to initialise ActiveRecord : #{e.message}"
    end
  end

end
