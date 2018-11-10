# frozen_string_literal: true

require_relative 'common/task_common'

module Yams

  module Docker

    class Dev < Thor

      include TaskCommon

      desc :up, 'Build development cluster : App, ELK container'

      method_option :init, type: :boolean, default: false

      def up
        docker_up('development')

        if(options[:init])
          docker_exec(cmd: 'bundle exec rake db:create')
          docker_exec(cmd: 'bundle exec rake db:migrate')
          docker_exec(cmd: 'bundle exec rake db:seed')
        end
      end

    end

    class Prod < Thor

      include TaskCommon

      desc :up, 'Build cluster : Db, SideKiq, Redis, ELK containers'

      def up
        cli = "docker-compose -f docker-compose.yml up --no-recreate -d sidekiq"
        puts "Running": cli
        system cli
      end

    end

  end

end
