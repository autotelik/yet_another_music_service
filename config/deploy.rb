# config valid for current version and patch releases of Capistrano
lock '~> 3.14.1'

set :application, 'yams'

set :repo_url, "git@github.com:autotelik/yet_another_music_service.git"

set :github_access_token, '1266d72ffc42dcf50140f86076beb6c4ef0a5f4f'

# Default branch is :master - to deploy another use - cap staging deploy BRANCH=PROC-7994-jade-server-issues
set :branch, ENV['BRANCH'] if ENV['BRANCH']

set :container_name, 'yams-web'

# Defaults to :db role
set :migration_role, :app

# Defaults to the primary :db server
set :migration_servers, -> { primary(fetch(:migration_role)) }

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

before :deploy, :stop_docker_containers

after :deploy,  :up_app_container

task :stop_docker_containers do
  on roles(:app) do
    # Stop existing APP  Container - ignore errors if container not available
    app_container_names.each do |c|
      begin
        execute "docker stop #{c}; echo 0"
        execute "docker rm -f #{c}; echo 0"
      rescue StandardError => e
        puts "WARNING - Failed to remove Container #{fetch(:container_name)} - #{e.message}"
      end
    end

    images = %W[yams-web-app_#{fetch(:stage)} yams-web-app_yams_sidekiq]

    images.each { |i| execute "docker rmi -f #{i}; echo 0" }

    invoke 'stop_other_containers'
  end
end

after 'deploy', :set_git_commit do
  on roles(:app) do
    `git rev-parse --short HEAD > public/git_release_rev`

    File.open('public/release_date', 'w') {|f| f << Time.now.strftime('%Y-%m-%d') }

    upload! 'public/git_release_rev', "#{deploy_to}/current/public"
    upload! 'public/release_date',    "#{deploy_to}/current/public"
  end
end

# Containers that should be removed and rebuilt fully
# Rebuild nginx incase certificates have changed
#
def app_container_names
  [fetch(:container_name), 'yams-sidekiq']
end

# Service containers that can be stopped and restarted
def container_names
  %w[yams-db yams-elasticsearch yams-redis]
end

task :stop_other_containers do
  on roles(:app) do
    container_names.each do |c|
      begin
        execute "docker stop #{c}; echo 0"
      rescue
        puts "WARNING - Failed to stop Container #{c}"
      end
    end
  end
end

task :up_app_container do
  on roles(:app) do
    # -p project means containers can be reused if unchanged
    execute "cd #{deploy_to}/current && GITHUB_TOKEN=#{fetch(:github_access_token)}  docker-compose -p yams-web-app -f docker-compose.yml up -d yams_web"
  end

  invoke 'container_admin'
end

task :container_admin do

  on roles(:app) do

    begin
      execute "docker exec #{fetch(:container_name)} bundle exec rake db:create RAILS_ENV=#{fetch(:rails_env)}"
    rescue => e
      # ignore - this only needed during first deploy # TODO make running it configurable
    end

  end
end
