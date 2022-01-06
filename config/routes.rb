Rails.application.routes.draw do
  resources :movies
  get 'movies/schedule/:id', to: 'movies#schedule'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'movies#index'
end
