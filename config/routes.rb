Rails.application.routes.draw do

  root 'home#index'

  get 'login' => 'login#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get 'logout' => 'sessions#destroy'

  #agreements
  get '/meetings/:meeting_id/agreements/:agreement_id' => 'agreements#edit'
  get '/meetings/:meeting_id/synod_designations/new' => 'synod_designations#new'
  get '/meetings/:meeting_id/new_admissions/new' => 'new_admissions#new'
  post '/meetings/:meeting_id/synod_designations' => 'synod_designations#create'
  post '/meetings/:meeting_id/new_admissions' => 'new_admissions#create'

  resources 'users'
  resources 'meetings'
  resources 'synod_designations', :except => [:new, :create]
  resources 'new_admissions', :except => [:new, :create]


end
