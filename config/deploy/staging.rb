# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

set :rails_env, "production"
server '46.32.230.11', user: 'yams', roles: %w{app db web}

set :linked_files, %w{config/.env config/master.key}

set :deploy_to, '/var/www/yams/deployment'

