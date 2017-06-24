Rails.application.routes.draw do

  get 'agreements/index'

  get 'agreements/show'

  get 'agreements/new'

  get 'agreements/edit'

  get 'meetings/index'

  get 'meetings/show'

  get 'meetings/new'

  get 'meetings/edit'

  root 'home#index'

  get 'login' => 'login#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get 'logout' => 'sessions#destroy'

  resources 'users'
  resources 'meetings'
  resources 'agreements'

end
