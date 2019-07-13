# config valid for current version and patch releases of Capistrano
#
#This links the folder specified in config.assets.prefix to shared/assets. If you already use this shared folder you'll need to write your own deployment task.

# It is important that this folder is shared between deployments so that remotely cached pages referencing the old compiled assets still work for the life of the cached page.
#load 'deploy/assets'

lock "~> 3.11.0"

set :application, "yams"

set :repo_url, "git@github.com:autotelik/yet_another_music_service.git"

set :deploy_to, '/var/www/vhosts/yams.fm/apps'

# Defaults to :db role
set :migration_role, :app

# Defaults to the primary :db server
set :migration_servers, -> { primary(fetch(:migration_role)) }

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# Defaults to [:web]
set :assets_roles, [:web, :app]

# Defaults to 'assets'
# This should match config.assets.prefix in your rails config/application.rb
set :assets_prefix, 'prepackaged-assets'

# Defaults to ["/path/to/release_path/public/#{fetch(:assets_prefix)}/.sprockets-manifest*", "/path/to/release_path/public/#{fetch(:assets_prefix)}/manifest*.*"]
# This should match config.assets.manifest in your rails config/application.rb
set :assets_manifests, ['app/assets/config/manifest.js']

# RAILS_GROUPS env value for the assets:precompile task. Default to nil.
set :rails_assets_groups, :assets

# If you need to touch public/images, public/javascripts, and public/stylesheets on each deploy
set :normalize_asset_timestamps, %w{public/images public/javascripts public/stylesheets}

# Defaults to nil (no asset cleanup is performed)
# If you use Rails 4+ and you'd like to clean up old assets after each deploy,
# set this to the number of versions to keep
set :keep_assets, 2

#after :deploy, :searchkick_reindex
#after 'deploy:updated', 'assets:precompile'

set :container_name, "yams_#{fetch(:stage)}"

before :deploy, :stop_docker_containers
after :deploy, :up_app_container

task :stop_docker_containers do
  on roles(:app) do
    invoke 'stop_other_containers'
  end
end

# Service containers that can be stopped and restarted
def container_names
  %w[yams_database yams_redis yams_elasticsearch yams_kibana yams_sidekiq]
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
    execute "cd #{deploy_to}/current && docker-compose -p yams_fm -f docker-compose.yml up -d db"
    execute "cd #{deploy_to}/current && docker-compose -p yams_fm -f docker-compose.yml up -d sidekiq"
  end

  invoke :container_admin
end

task :container_admin do
  on roles(:app) do
    within current_path do  # TOFIX: does not seem to work - still need to cd to /var/www/vhosts/yams.fm/apps/current
      begin
        #cd /var/www/vhosts/yams.fm/apps/current
        execute "cd /var/www/vhosts/yams.fm/apps/current && /var/www/vhosts/yams.fm/.rvm/gems/ruby-2.5.1/wrappers/ruby -S bundle install --no-deployment --without development test"
      rescue => e
      end

      begin
        execute "cd /var/www/vhosts/yams.fm/apps/current && /var/www/vhosts/yams.fm/.rvm/gems/ruby-2.5.1/wrappers/ruby -S bundle exec rake assets:precompile RAILS_ENV=production"
      rescue => e
        puts "Assets precompile failed : #{e.inspect}"
      end

      begin
        # Sort out any issues with permissions etc
        execute "cd /var/www/vhosts/yams.fm/apps/current && chmod 0664 #{fetch(:deploy_to)}/current/log/*.log"
      rescue => e
        puts "Container admin failed : #{e.inspect}"
      end
    end
  end
end


desc 'Run a searchkick:reindex task on all models'
task :searchkick_reindex do
  on roles(:app) do
    within current_path do
      begin
        execute '/var/www/vhosts/yams.fm/.rvm/gems/ruby-2.5.1/wrappers/ruby -S bundle exec thor yams:search_index:build'
      rescue
      end
    end
  end
end

namespace :assets do
  desc 'Precompile assets locally and then rsync to web servers'
  task :precompile do
    run_locally do
      with rails_env: stage_of_env do
        execute :bundle, 'exec rake assets:precompile'
      end
    end

    on roles(:web), in: :parallel do |server|
      run_locally do
        execute :rsync,
                "-a --delete ./public/packs/ #{fetch(:user)}@#{server.hostname}:#{shared_path}/public/packs/"
        execute :rsync,
                "-a --delete ./public/assets/ #{fetch(:user)}@#{server.hostname}:#{shared_path}/public/assets/"
      end
    end

    run_locally do
      execute :rm, '-rf public/assets'
      execute :rm, '-rf public/packs'
    end
  end
end


