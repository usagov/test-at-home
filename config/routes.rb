Rails.application.routes.draw do
  scope "(:locale)", locale: /en|es/ do
    resources :kit_requests, only: %i[create]
    get "kit_requests", to: "kit_requests#confirmation", as: :kit_request_confirmation

    root "kit_requests#new"
  end
end
