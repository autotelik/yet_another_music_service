# frozen_string_literal: true
class SetupDev < Thor

  desc :clean, 'Drop Db, remove containers and reinstall everything from scratch'

  def clean
    system('bundle exec thor yams_core:docker:dev:up')

    system('bundle install')
    system('bundle exec rake db:drop')

    puts 'Create the DB'
    #system('bundle exec rails yams_core:install:migrations')
    system('bundle exec rails yams_events:install:migrations')

    system('bundle exec rake db:create')

    puts 'Migrating the DB'
    system('bundle exec rake db:migrate')

    puts 'Seed the DB - bundle exec rake db:seed'
    system('bundle exec rake db:seed')

    puts 'Seed the example Music - bundle exec thor yams:db:seed_music'
    system('bundle exec thor yams:db:seed_music')
  end

end
