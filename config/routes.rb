Rails.application.routes.draw do

  root 'home#index'

  get 'login' => 'login#index'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get '/logout' => 'sessions#destroy'
  get '/menu-items' => 'home#menu_items'
  post '/agreements/:agreement_id/send_email' => 'agreements#send_vote_reminder'
  post '/agreements/:id/close_agreement' => 'agreements#close_agreement'

  # agreements
  get '/agreements/:agreement_id/edit' => 'agreements#edit'

  get '/meetings/:meeting_id/synod_designations/new' => 'synod_designations#new'
  get '/meetings/:meeting_id/new_admissions/new' => 'new_admissions#new'
  get '/meetings/:meeting_id/professional_exams/new' => 'professional_exams#new'
  get '/meetings/:meeting_id/tutor_committees/new' => 'tutor_committees#new'

  get '/meetings/:id/new_agreement' => 'meetings#new_agreement'
  get '/agreements/:id/files' => 'agreements#agreement_files'
  get '/agreement_files/:id' => 'agreements#display_agreement_file'
  get '/agreements/:id/student_record/:student_id' => 'agreements#student_record'
  delete '/agreements/:id' => 'agreements#destroy'
  delete '/meetings/:id' => 'meetings#destroy'
  get '/dashboard' => 'home#dashboard'

  #
  post '/meetings/:meeting_id/synod_designations' => 'synod_designations#create'
  post '/meetings/:meeting_id/tutor_committees' => 'tutor_committees#create'
  post '/meetings/:meeting_id/new_admissions' => 'new_admissions#create'
  post '/meetings/:meeting_id/professional_exams' => 'professional_exams#create'
  post '/agreements/:id/send_response' => 'agreements#send_response'
  post '/agreements/:id/upload_file' => 'agreements#upload_file'
  delete '/agreement_files/:id' => 'agreements#delete_file'

  resources 'users'
  resources 'meetings'
  resources 'agreements', :only => [:show,:index]
  resources 'synod_designations', :except => [:new, :create, :show]
  resources 'new_admissions', :except => [:new, :create, :show]
  resources 'professional_exams', :except => [:new, :create, :show]
  resources 'tutor_committees', :except => [:new, :create, :show]


end
