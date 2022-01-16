Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join('|')}/ do
    resources :kit_requests, only: %i[create]

    root "kit_requests#new"
  end
end
