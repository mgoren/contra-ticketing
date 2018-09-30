Rails.application.routes.draw do
  root 'static_pages#welcome'
  get 'welcome', to: 'static_pages#welcome'
  resources :orders, only: [:new, :create]
end
