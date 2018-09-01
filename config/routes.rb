Rails.application.routes.draw do
  # Users and Sessions
  resources :users do
    resources :pictures, module: :users
  end
  post '/promote', to:  'users#promote'
  post '/invite',  to:  'users#invite'

  resources :sessions, only: %i[index new create destroy]
  get '/sesame_login' => 'sessions#new'
  get '/unknown_user' => 'sessions#unknown'
  delete '/logout', to: 'sessions#destroy', as: :sign_out

  get '/auth/:provider/callback', to: 'sessions#create'

  # Events
  resources :courses, controller: :courses, type: 'Course'

  resources :performances, controller: :performances, type: 'Performance'
  resources :performances do
    resources :pictures, module: :events
  end

  # Coaches
  resources :coaches

  # Polls
  resources :polls, only: %i[index]
  resources :poll_opinions, controller: :poll_opinions, type: 'PollOpinion' do
    # Votes
    resources :vote_opinions,
              controller: :vote_opinions,
              type: 'VoteOpinion',
              shallow: true #  [:index, :new, :create] are nested
  end
  resources :poll_dates, controller: :poll_dates, type: 'PollDate' do
    # Votes
    resources :vote_dates,
              controller: :vote_dates,
              type: 'VoteDate'
  end

  # Answers
  resources :answers

  # Theaters
  resources :theaters

  # Dashboard
  get  '/dashboard'   => 'dashboards#index'

  # Splash
  post '/signup'      => 'splash#signup', as: :splash_signup
  get  '/splash'      => 'splash#index'

  root 'splash#index'
end
