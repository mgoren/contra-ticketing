Rails.application.routes.draw do
  root 'orders#new'
  get 'welcome', to: 'static_pages#welcome'
  get 'tshirts', to: 'static_pages#tshirts'
  resources :orders, only: [:new, :create]
end
