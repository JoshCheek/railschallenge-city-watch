Rails.application.routes.draw do
  get   '/emergencies'       => 'emergencies#index'
  post  '/emergencies'       => 'emergencies#create'
  get   '/emergencies/:code' => 'emergencies#show'
  patch '/emergencies/:code' => 'emergencies#update'

  match '*_' => 'application#not_found!', via: :all
end
