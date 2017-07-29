Rails.application.routes.draw do

  root 'cards#index'

  get '/new',  to: 'cards#new'
  get '/:id/edit',  to: 'cards#edit'
  get '/results', to: 'cards#results'

  resources :cards

end
