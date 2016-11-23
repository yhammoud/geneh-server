Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'api#get_exchange_rate'
  get '/api/exchange_rate' => 'api#get_exchange_rate'


  get '/notifications/new' => 'notifications#new'
  post '/notifications/push' => 'notifications#push'
end
