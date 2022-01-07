Rails.application.routes.draw do
  resources :kit_requests, only: %i[create]

  root "kit_requests#new"
end
