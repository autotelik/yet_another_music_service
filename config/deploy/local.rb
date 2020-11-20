require 'capistrano/copy'


set :rails_env, "production"
server '46.32.230.11', user: 'yams', roles: %w{app db web}

append :linked_files, ".env"

set :tmp_dir,   '/var/www/warp/deployment/tmp'
set :deploy_to, '/var/www/warp/deployment'

set :scm, :copy
