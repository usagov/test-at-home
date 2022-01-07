Rails.application.routes.draw do
  resources :kit_requests, only: %i[new create]
  get "kit_requests/confirmation", to: "kit_requests#confirmation", as: :kit_request_confirmation

  root "pages#home"
end
