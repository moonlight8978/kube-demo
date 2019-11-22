Rails.application.routes.draw do
  root 'calculatings#index'

  resources :calculatings, only: [:index, :create]
end
