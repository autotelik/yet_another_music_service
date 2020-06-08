Rails.application.routes.draw do


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount YamsCore::Engine, at: "/"
  mount YamsEvents::Engine, at: "/ecommerce"

  root to: 'visitors#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  mount RailsEventStore::Browser => '/res' if Rails.env.development?

end
