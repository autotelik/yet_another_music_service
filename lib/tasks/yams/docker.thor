# frozen_string_literal: true

module Yams

  class Docker < Thor
    include TaskCommon

    desc :dev, 'Build development cluster : Sidekiq, DB, ELK'

    method_option :sidekiq, type: :boolean, default: false, desc: 'Also spin up Sidekiq container'

    def dev
      load_rails_environment

      # no impact if already created
      system 'docker network create webproxy'

      %w[yams_db yams_elasticsearch yams_redis].each { |c| docker_up(c) }

      docker_up('yams_sidekiq') if options[:sidekiq]
    end

    desc :compose, 'Run docker compose to build full cluster (Db, SideKiq, Redis, ELK)'

    method_option :init, type: :boolean, default: false

    def compose
      load_rails_environment

      system 'docker network create webproxy'

      cli = 'docker-compose -f docker-compose.yml up --no-recreate -d yams_web'
      puts 'Running', cli
      system cli

      return unless options[:init]

      docker_exec(container: 'yams-db', cmd: 'bundle exec rake db:create')
      docker_exec(container: 'yams-db', cmd: 'bundle exec rake db:migrate')
      docker_exec(container: 'yams-db', cmd: 'bundle exec rake db:seed')
    end

    %w[Db Elasticsearch Redis Sidekiq].each do |name|
      desc :"#{name.downcase}", "Start #{name} docker container"

      define_method(name.downcase.to_s) do
        load_rails_environment

        docker_up("--no-deps yams_#{name.downcase}")
      end
    end
  end

end
