Rails.application.routes.draw do

  namespace :admin do
    resources :users
    root to: "users#index"
  end

  mount YamsCore::Engine, at: "/"

  root to: 'visitors#index'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end
