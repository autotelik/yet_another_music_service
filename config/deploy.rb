require "delayed/recipes"

default_run_options[:pty] = true

set :runner, nil
set :application, "YAMS"
set :repository,  "."
set :tmp_dir,"/tmp/deploy/#{application}"
set :copy_dir,"/tmp/"
set :deploy_to, ENV['YAMS_CAP_DEPLOY_TO']
set :scm, :none
set :deploy_via, :copy
set :checkout, "export"
set :use_sudo, false

# Other app containers YAMS relies on
def container_names
  %w{elasticsearch logstash kibana}
end

def staging_common
  set :rails_env, "staging"

  role :docker, 'yams'
  role :db,     'yams', :primary => true

  set :deploy_to, "/var/rails_apps/docker/#{application}"
  set :user, 'yams.developer'
  set :server_name, "yams.autotelik.co.uk"

  before :deploy, :restart_docker
end

# ALL Containers
def docker_staging_rebuild
  puts "*********** DEPLOYING FULL DOCKER STACK  ***********"
  staging_common

  before :deploy, :restart_docker

  after :deploy, :stop_yams, :remove_other_containers, :rm_yams_container, :up_all_containers
end

# YAMS ONLY
def docker_staging
  puts "*********** DEPLOYING YAMS DOCKER CONTAINER ***********"
  staging_common

  before :deploy, :restart_docker

  after :deploy, :stop_other_containers, :stop_yams, :rm_yams_container, :up_wem_mis_container
end


def docker_prod_rebuild
  set :rails_env, "production"
  puts "*********** DEPLOYING FULL DOCKER STACK TO PRODUCTION ***********"

  # TODO - CONFIRM THE SERVERS
  role :docker, 'yams01'
  role :db,     'yams01', :primary => true

  set :deploy_to, "/var/rails_apps/docker/#{application}"
  set :user, 'rails.prod'
  set :server_name, "yams01.autotelik.co.uk"

  before :deploy, :restart_docker

  after :deploy, :stop_other_containers, :stop_yams, :rm_yams_container, :up_all_containers
end



if env && env == 'production'
  set :rails_env, "production" #added for delayed job
  puts "*********** DEPLOYING TO PRODUCTION ***********"
  before 'deploy', 'mv_dir_to_tmp'
  role :app, "msbackoffice05"
  role :web, "msbackoffice05"
  role :db,  "msbackoffice05", :primary => true
  set :user, 'rails.prod'
  set :server_name, "msbackoffice05.autotelik.co.uk"


elsif env && env == 'staging'
  set :rails_env, "staging" #added for delayed job
  puts "*********** DEPLOYING TO STAGING ***********"
  before 'deploy', 'rm_models'
  role :app, "msbackoffice06"
  role :web, "msbackoffice06"
  role :db,  "msbackoffice06", :primary => true
  set :user, 'rails.test'
  set :server_name, "msbackoffice06.autotelik.co.uk"


elsif env && env == 'docker_staging_rebuild'    # ALL Containers
  docker_staging_rebuild

elsif env && env == 'docker_prod_rebuild'       # ALL Containers
  docker_prod_rebuild

elsif env && env == 'docker_staging'            # ONLY YAMS
  docker_staging

elsif env && env == 'docker_prod'               # ONLY YAMS
  docker_prod

else
  puts "Please specify valid environment"
  return
end

task :copy_files do
  if env && env == 'production'
    print "Cleanup temporary directory #{tmp_dir}\n"
    system "rm -rf #{tmp_dir}"
  end
end

task :mv_dir_to_tmp do
  print "Copy project to writeable tmp-dir\n"
  system "mkdir -p #{tmp_dir}"
  system "cp -R #{repository} #{tmp_dir}"
  system "chmod -R 777 #{tmp_dir}"
  print "Removing Gemfile.lock\n"
  system "rm #{tmp_dir}/Gemfile.lock"
  print "Remove the app/models link if it exists\n"
  system "rm -f #{tmp_dir}/app/models"
  set :repository, "#{tmp_dir}"
end

# Automounted drives cause an issue with docker that actually breaks the host server, any directory
# related commands such as cd will fails with
#   -bash: cd: /data/users/rails.test: Too many levels of symbolic links
#
# The only solution to this issue, once it's been triggered is to restart docker
#
task :restart_docker do
  sudo 'service docker restart'
end


task :rm_models do
  print "Remove the app/models link if it exists\n"
  system "rm -f #{repository}/app/models"
end

# Stop existing YAMS Container - ignore errors if container not available
task :stop_yams, :on_error => :continue do
  container_name = fetch(:rails_env)
  run "docker exec -it #{container_name} bundle exec script/delayed_job stop"
  run "docker stop #{container_name}; echo 0"
end

# Stop and remove existing YAMS Container - ignore errors if container not present
task :rm_yams_container do
  container_name = fetch(:rails_env)
  begin
    run "docker rm -f #{container_name}; echo 0"
  rescue => e
    puts "WARNING - Failed to remove Container #{container_name} - #{e.message}"
  end
end


# Stop existing services within Container - ignore errors if container not available

# N.B Either a bug or something odd with our setup but the suggested tag
#     :on_error => :continue
# will cause Capistrano to fail with * no servers for <command> hence we use our own exception handling

task :stop_other_containers do
  container_names.each do |c|
    begin
      run "docker stop #{c}; echo 0"
    rescue
      puts "WARNING - Failed to stop Container #{c}"
    end
  end
end

task :remove_other_containers do
  container_names.each do |c|
    begin
      run "docker stop #{c}; echo 0"
    rescue
      puts "WARNING - Failed to remove Container #{c}"
    end
    begin
      # Do not remove ES volumes - retain the data
      run "docker rm -f #{c}; echo 0"
    rescue
      puts "WARNING - Failed to remove Container #{c}"
    end
  end
end


# Go Live type task
task :up_all_containers do
  container_name = fetch(:rails_env)
  puts "================Starting Docker setup===================="

  # We have automounted volumes, seems auto mount point has to be visible BEFORE we enter the Container to avoid errors

  dirs_to_touch = "cd /data; cd /data/id; cd /data/RegressionTest; cd /data/newgroups; cd /data/ops2; cd /data/testgrid/"
  run dirs_to_touch + " ; cd #{deploy_to}/current && docker-compose -f docker-compose.yml -f docker/services/#{container_name}.yml up -d #{container_name}"

  # Update the DB schema
  #run "docker exec -it #{container_name} bundle exec rake db:migrate"

  # Hack around permission issues caused by passenger starting a few things as root, before switching to app
  #run "docker exec -it #{container_name} chown -R app:www-data /home/app/log" # db:migrate writes a log as root
  #run "docker exec -it #{container_name} chgrp -R www-data /home/app/tmp/"

  # Yams uses delayed job for background tasks - https://github.com/collectiveidea/delayed_jobn
 # run "docker exec -it #{container_name} script/delayed_job start"

  # bit odd cos in compose containers *depend* on ES, but without sleep, ES container often not available at this point
  #loop do
  #  sleep 2
  #  break if(capture("docker inspect -f '{{.State.Running}}' elasticsearch").strip == 'true')
  #end

  # Full rebuild so perform full index reset e.g on go live  deploy
  # TODO - check how data is stored in ES data volume - definitly persists between container stop/starts ??
  #run "docker exec -it #{container_name} bundle exec rake chewy:reset"
end


# YAMS only Release
task :up_wem_mis_container do
  container_name = fetch(:rails_env)
  puts "================Starting Docker setup===================="

  dirs_to_touch = "cd /data; cd /data/id; cd /data/RegressionTest; cd /data/newgroups; cd /data/ops2; cd /data/testgrid/"
  run dirs_to_touch + " ; cd #{deploy_to}/current && docker-compose -f docker-compose.yml -f docker/services/#{container_name}.yml up --no-recreate -d #{container_name}"

  # Update the DB schema
  run "docker exec -it #{container_name} bundle exec rake db:migrate"

  # Hack around permission issues caused by passenger starting a few things as root, before switching to app
  run "docker exec -it #{container_name} chown -R app:www-data /home/app/log" # db:migrate writes a log as root
  run "docker exec -it #{container_name} chgrp -R www-data /home/app/tmp/"

  # Update the Elastic Search indexes, based off any changes to e.g app/chewy/web_mis_index.rb
  # Without this wait, indexing often fails as the ES container still spinning up.
  run "sleep 10"

  run "docker exec -it #{container_name} bundle exec rake chewy:deploy"
  run "docker exec -it #{container_name} script/delayed_job start"
end


namespace :bundle do

  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    sudo "bundle install --gemfile #{release_path}/Gemfile --without development test"
    sudo "chown -R '#{user}' #{release_path}"
  end

end


# Tasks for NON DOCKER deploys

deploy.task :restart, :roles => :app do
  if env && env !~ /docker/
    sudo "chgrp -R www-data #{release_path}"
    sudo "chmod -R 770 #{release_path}"
    run "touch #{current_path}/tmp/restart.txt"
  end
end

if env && env !~ /docker/
  before "whenever:update_crontab", "bundle:install"

  after "deploy:stop",    "delayed_job:stop"
  after "deploy:start",   "delayed_job:start"
  after "deploy:restart", "delayed_job:restart"

  after "deploy:finalize_update", "copy_files"

  set :whenever_environment, defer { env }
  set :whenever_identifier, defer { "#{application}_#{env}" }
  set :whenever_command, "bundle exec whenever"
  set :whenever_variables, defer { "'environment=#{env}&current_path=#{current_path}'" }
  require 'whenever/capistrano'
  after 'deploy:finalize_update','whenever:update_crontab'
end