Rails.application.routes.draw do

  root 'home#index'

  get 'login' => 'login#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get 'logout' => 'sessions#destroy'

  resources 'users'

end
