Rails.application.routes.draw do

  mount YamsCore::Engine, at: "/"

  root to: 'visitors#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  #mount RailsEventStore::Browser => '/res' if Rails.env.development?

end
