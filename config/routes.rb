Rails.application.routes.draw do
  root 'orders#new'
  get 'tshirts', to: 'static_pages#tshirts'
  resources :orders, only: [:new, :create]
end
