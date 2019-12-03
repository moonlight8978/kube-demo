Rails.application.routes.draw do
  root 'calculatings#index'

  get 'health_check', to: 'health_check#index'

  resources :calculatings, only: %i[index create]
end
