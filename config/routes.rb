Rails.application.routes.draw do
  get    '/emergencies'          => 'emergencies#index', as: :emergencies
  post   '/emergencies'          => 'emergencies#create'
  # get    '/emergencies/new'      => 'emergencies#new',   as: :new_emergency
  # get    '/emergencies/:code/edit' => 'emergencies#edit',  as: :edit_emergency
  get    '/emergencies/:code'      => 'emergencies#show',  as: :emergency
  # patch  '/emergencies/:code'      => 'emergencies#update'
  # put    '/emergencies/:code'      => 'emergencies#update'
  # delete '/emergencies/:code'      => 'emergencies#destroy'
end
