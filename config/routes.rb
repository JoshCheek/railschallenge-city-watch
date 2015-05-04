Rails.application.routes.draw do
  get   '/emergencies'       => 'emergencies#index'
  post  '/emergencies'       => 'emergencies#create'
  get   '/emergencies/:code' => 'emergencies#show'
  patch '/emergencies/:code' => 'emergencies#update'

  match '*_', via: :all, to: lambda { |env|
    body = '{"message":"page not found"}'
    [ 404,
      { 'Content-Type'   => 'application/json; charset=utf-8',
        'Content-Length' => body.length,
      },
      [body]
    ]
  }
end
