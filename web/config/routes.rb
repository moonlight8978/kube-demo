Rails.application.routes.draw do
  root 'calculatings#index'

  resources :calculatings, only: %i[index create]
end
