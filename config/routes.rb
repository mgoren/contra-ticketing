Rails.application.routes.draw do
  # root 'static_pages#unavailable'
  root 'orders#new'
  # get 'tshirts', to: 'static_pages#tshirts'
  # get 'unavailable', to: 'static_pages#unavailable'
  resources :orders, only: [:new, :create]
end
