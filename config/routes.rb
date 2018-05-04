Rails.application.routes.draw do
  # Sessions
  resources :sessions, only: %i[index new create destroy]
  get '/sesame_login' => 'sessions#new'
  get '/unknown_user' => 'sessions#unknown'
  delete '/logout', to: 'sessions#destroy', as: :sign_out

  get '/auth/:provider/callback', to: 'sessions#create'
  # Users, theaters, Events
  resources :users, :theaters, :events, :pictures
  post '/promote',        to:  'users#promote'
  post '/invite',        to:  'users#invite'
  # Splash
  post '/signup'      => 'splash#signup', as: :splash_signup
  get  '/splash'      => 'splash#index'
  # Dashboard
  get  '/dashboard'   => 'dashboards#index'

  root 'splash#index'
end
