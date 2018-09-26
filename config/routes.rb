Rails.application.routes.draw do

  namespace :admin do
    resources :users
    root to: "users#index"
  end
  root to: 'visitors#index'

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  devise_scope :user do
    get 'users/:id' => 'users/registrations#show', as: :user
  end

  resources :albums do
    delete :tracks, as: :clear_tracks
  end

  resources :album_tracks, only: [:create, :destroy, :edit, :index], module: 'album_track' do
    resources :track_selections, only: [:create]
  end

  resources :radio, only: [:index]

  resources :id3_genres
  resources :licenses

  resource :searches, only: [:show]
  resources :tracks

  mount DatashiftAudioEngine::Engine, at: "/audio"

  post '/player_save_callback', to: 'player_save_callback#create'

end
