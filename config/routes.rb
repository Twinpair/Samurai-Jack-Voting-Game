Rails.application.routes.draw do

  root 'cards#enemies'

  get '/new',  to: 'cards#new'
  get '/:id/edit',  to: 'cards#edit'
  get '/outfits',  to: 'cards#outfits'
  get '/allies',  to: 'cards#allies'
  get '/results', to: 'cards#results'
  get '/results/enemies', to: 'cards#results_enemies'
  get '/results/outfits', to: 'cards#results_outfits'
  get '/results/allies', to: 'cards#results_allies'
  get 'category/new', to: 'categories#new'
  get 'category/:id/edit', to: 'categories#edit'

  resources :cards
  resources :categories

end
