Rails.application.routes.draw do
  root 'static_pages#welcome'
  get 'welcome', to: 'static_pages#welcome'
  get 'tshirts', to: 'static_pages#tshirts'
  resources :orders, only: [:new, :create]
end
