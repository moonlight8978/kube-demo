Rails.application.routes.draw do
  resources :calculatings, only: [:index, :create]
end
