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
      #       desc :up_with_data, 'Build a new development cluster and POPULATE DB container'
      #
      #       method_option :name, aliases: '-n', desc: 'Name of the DB data service (container)', default: 'data'
      #       method_option :db, aliases: '-d', desc: 'MySQL data volume to load'
      #
      #       def up_with_data
      #         # To bring up ONLY DB container run
      #         system 'docker-compose build data'
      #         system 'docker-compose up -d data'
      #
      #         # Populate a Rails 4 database with a carinamarina generated volume (not an sql dump - which is much slower):
      #
      #         puts "Starting carinamarina volume load into #{options[:name]}"
      #         system "docker run --rm --interactive --volumes-from #{options[:name]} carinamarina/backup restore --destination /var/lib/mysql/ --stdin --zip < #{options[:db]}"
      #
      #         # Container running but without a restart, seems the new data is not visible externally
      #         system "docker-compose restart  #{options[:name]}"
      #
      #         # Now we can bring up the rest
      #         docker_up('development')
      #       end
      #
      #       desc :create_volume_backup, 'Create a carinamarina backup from a MySQL Container'
      #
      #       method_option :name, aliases: '-n', desc: 'Name of the DB data service (container).', default: 'data'
      #
      #       method_option :dump, aliases: '-d', desc: 'Location to store the dump.',
      #                            default:  File.join(backup_basepath, "db-data-volume-#{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.tar.gz")
      #
      #       method_option :copy_to_latest, aliases: '-c', desc: "Store successful dump as latest (in #{File.join(backup_basepath, 'latest')})"
      #
      #       def create_volume_backup
      #         name = options[:name]
      #         system "docker run --rm --volumes-from #{name} carinamarina/backup backup --source  /var/lib/mysql/ --stdout --zip > #{options[:dump]}"
      #       end
      no_commands do
        def self.backup_basepath
          '/tmp'
        end
      end

    end
  end

end
