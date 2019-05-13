Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "homepage#index"

  resources :categories, only: [:create, :index, :new]
  resources :orderitems
  resources :orders
  resources :products

  # NEW ROUTE
  patch "/users/:uid/products/:id/retire_product", to: "products#retire_product", as: "retire_product"

  # nested routes
  resources :categories do
    resources :products, only: [:index]
  end

  get "/users/current", to: "users#current", as: "current_user"

  resources :users do
    resources :products
  end

  resources :products do
    resources :reviews, only: [:new, :create, :index]
  end

  resources :products do
    resources :orderitems, only: [:new, :create]
  end

  resources :shoppingcarts, only: [:show]

  # custom routes

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"
  delete "/logout", to: "users#destroy", as: "logout"
  get "/order/:id/confirmations", to: "confirmations#index", as: "confirm_order"
end
