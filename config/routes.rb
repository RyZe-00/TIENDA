Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :cart_products
  resources :product_images
  resources :product_reviews
  resources :product_categories
  resources :payments
  resources :order_items
  resources :order_states
  resources :user_addresses
  resources :user_roles
  resources :reports
  resources :carts
  resources :products
  resources :orders
  resources :users
  resources :categories
  resources :payment_methods
  resources :payment_states
  resources :roles
  resources :states
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
