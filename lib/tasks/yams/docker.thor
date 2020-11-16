# frozen_string_literal: true

module Yams

  class Docker < Thor
    include TaskCommon

    desc :dev, 'Build development cluster : Sidekiq, DB, ELK'

    method_option :init, type: :boolean, default: false
    method_option :sidekiq, type: :boolean, default: false, desc: 'Also spin up Sidekiq container'

    def dev
      load_rails_environment

      %w[yams_db yams_elasticsearch yams_redis].each { |c| docker_up(c) }

      docker_up('yams_sidekiq') if options[:sidekiq]

      return unless options[:init]

      docker_exec(cmd: 'bundle exec rake db:create')
      docker_exec(cmd: 'bundle exec rake db:migrate')
      docker_exec(cmd: 'bundle exec rake db:seed')
    end


    desc :compose, 'Run docker compose to build full cluster (Db, SideKiq, Redis, ELK)'

    def compose
      load_rails_environment

      system 'docker network create webproxy'

      cli = 'docker-compose -f docker-compose.yml up --no-recreate -d yams_web'
      puts 'Running', cli
      system cli
    end


    %w[Elasticsearch Redis Sidekiq].each do |name|
      klass = Class.new(Thor) do
        include TaskCommon

        desc :up, "Start #{name} docker container"

        method_option :init, type: :boolean, default: false, desc: 'Initialise the DB'

        define_method(:up) do
          load_rails_environment

          docker_up("--no-deps yams_#{name.downcase}")

          if options[:init]
            docker_exec(cmd: 'bundle exec rake db:create')
            docker_exec(cmd: 'bundle exec rake db:migrate')
            docker_exec(cmd: 'bundle exec rake db:seed')
          end
        end
      end

      Yams.const_set name, klass
    end

  end

end
