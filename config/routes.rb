Rails.application.routes.draw do
  get "homepage/index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "homepage#index"

  resources :categories, only: [:create, :index, :new]
  resources :orderitems
  resources :orders
  resources :products

  # nested routes
  resources :categories do
    resources :products, only: [:index]
  end

  resources :users do
    resources :products
  end

  resources :products do
    resources :reviews, only: [:new, :create, :index]
  end

  resources :orders do
    resources :orderitems
  end

  resources :products do
    resources :orderitems
  end

  # custom routes
  delete "/logout", to: "users#logout", as: "logout"
  get "/users/current", to: "users#current", as: "current_user"
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"

  # May have to change this route, maybe we don't need this page. this sounds like a view rendering
  # where we will render the order show page. If it is a new order, we will render the sentence "Order Confirmed!"
  get "/order/:id/confirmation", to: "orders#confirmation", as: "confirm_order"

  # NEED A ROUTE FOR CONNECTING USER BY ID TO PRODUCT BY ID TO ORDER_ITEM
end
