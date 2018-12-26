require 'sidekiq/web'
Rails.application.routes.draw do
  mount Commontator::Engine => '/commontator'
  # Users and Sessions
  resources :settings, only: %i[index edit update]

  resources :users do
    resources :pictures, module: :users
    member do
      mount Sidekiq::Web => '/sidekiq'
      patch '/promote',     to: 'users#promote'
      patch '/bio',         to: 'users#bio'
      patch '/invite',      to: 'users#invite'
      get '/about_me',      to: 'users#about_me'
    end
  end

  resources :sessions, only: %i[index new create destroy]
  get '/sesame_login' => 'sessions#new'
  get '/unknown_user' => 'sessions#unknown'
  delete '/logout', to: 'sessions#destroy', as: :sign_out

  get '/auth/:provider/callback', to: 'sessions#create'

  # Events
  resources :courses, controller: :courses, type: 'Course'

  resources :performances,
            controller: :performances,
            type: 'Performance' do
    resources :pictures, module: :events
  end

  # Answers, Committes, Theaters, Coaches, Exercices
  resources :answers, :theaters, :coaches, :exercices

  # Polls
  resources :polls, only: %i[index new]

  resources :poll_opinions, controller: :poll_opinions, type: 'PollOpinion' do
    # Votes
    resources :vote_opinions,
              controller: :vote_opinions,
              type: 'VoteOpinion',
              shallow: true #  [:index, :new, :create] are nested
  end
  resources :poll_secret_ballots,
            controller: :poll_secret_ballots,
            type: 'PollSecretBallot' do
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


  # Dashboard
  get  '/dashboard'   => 'dashboards#index'

  # Splash
  post '/signup'      => 'splash#signup', as: :splash_signup
  get  '/splash'      => 'splash#index'

  root 'splash#index'
end
