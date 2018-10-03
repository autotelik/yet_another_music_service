puts "Config Sidekiq REDIS #{ENV['JOB_WORKER_URL']}"

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['JOB_WORKER_URL'] }
end

# This can be useful during dev cycle - Perform Sidekiq jobs immediately in development,
# so you don't have to run a separate process.
#
#if Rails.env.development?
#  require 'sidekiq/testing'
#  Sidekiq::Testing.inline!
#end
#
