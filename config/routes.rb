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
  get '/meetings/:meeting_id/professional_exams/new' => 'professional_exams#new'

  post '/meetings/:meeting_id/synod_designations' => 'synod_designations#create'
  post '/meetings/:meeting_id/new_admissions' => 'new_admissions#create'
  post '/meetings/:meeting_id/professional_exams' => 'professional_exams#create'
  post '/agreements/:id/send_response' => 'agreements#send_response'

  resources 'users'
  resources 'meetings'
  resources 'agreements', :only => [:show]
  resources 'synod_designations', :except => [:new, :create, :show]
  resources 'new_admissions', :except => [:new, :create, :show]
  resources 'professional_exams', :except => [:new, :create, :show]


end
