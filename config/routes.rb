Rails.application.routes.draw do
  get    '/emergencies'          => 'emergencies#index', as: :emergencies
  post   '/emergencies'          => 'emergencies#create'
  # get    '/emergencies/new'      => 'emergencies#new',   as: :new_emergency
  # get    '/emergencies/:id/edit' => 'emergencies#edit',  as: :edit_emergency
  # get    '/emergencies/:id'      => 'emergencies#show',  as: :emergency
  # patch  '/emergencies/:id'      => 'emergencies#update'
  # put    '/emergencies/:id'      => 'emergencies#update'
  # delete '/emergencies/:id'      => 'emergencies#destroy'
end
