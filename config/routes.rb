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
  resource :cart, only: [:show, :destroy] do
    post 'add_product/:product_id', to: 'carts#add_product', as: 'add_product'
    post 'update_quantity/:product_id', to: 'carts#update_quantity', as: 'update_quantity'
    post 'remove_product/:product_id', to: 'carts#remove_product', as: 'remove_product'
    
    # Nuevas rutas para los usuarios registrados
    delete 'remove2/:product_id', to: 'carts#remove_product2', as: 'remove_product2'
    patch 'update_quantity2/:product_id', to: 'carts#update_quantity2', as: 'update_quantity2'
  end
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
