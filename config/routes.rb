Rails.application.routes.draw do

  root 'home#index'

  get 'login' => 'login#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get 'logout' => 'sessions#destroy'

  #agreements
  get '/meetings/:meeting_id/agreements/:agreement_id' => 'agreements#edit'

  resources 'users'
  resources 'meetings'
  resources 'synod_designations'
  resources 'new_admissions'


end
