Rails.application.routes.draw do
  # Splash
  post '/signup'      => 'splash#signup', as: :splash_signup
  get  '/splash'      => 'splash#index'
  
  root 'splash#index'
end
