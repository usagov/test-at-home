Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join('|')}/ do
    resources :kit_requests, only: %i[create]
    get "error", to: "kit_requests#error"

    root "kit_requests#new"
  end
end
