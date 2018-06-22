Rails.application.routes.draw do
  # Sessions
  resources :sessions, only: %i[index new create destroy]
  get '/sesame_login' => 'sessions#new'
  get '/unknown_user' => 'sessions#unknown'
  delete '/logout', to: 'sessions#destroy', as: :sign_out

  get '/auth/:provider/callback', to: 'sessions#create'
  # Users, theaters, Events
  resources :performances, controller: :performances, type: 'Performance'
  resources :courses, controller: :events, type: 'Course'
  resources :performances do
    resources :pictures, module: :events
  end

  resources :users do
    resources :pictures, module: :users
  end
  resources :theaters
  post '/promote',        to:  'users#promote'
  post '/invite',        to:  'users#invite'
  # Splash
  post '/signup'      => 'splash#signup', as: :splash_signup
  get  '/splash'      => 'splash#index'
  # Dashboard
  get  '/dashboard'   => 'dashboards#index'

  root 'splash#index'
end
