Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :categories, only: [:create, :index, :new]
  resources :orderitems
  resources :orders
  resources :products
  resources :reviews, only: [:new, :create]
  

  # nested routes
  resources :categories do
    resources :products, only: [:index]
  end

  resources :users do
    resources :products
  end

  # custom routes
  # May have to change this route
  post "/products/:id/review", to: "products#review", as: "review"
  
  delete "/logout", to: "users#logout", as: "logout"
  get "/users/current", to: "users#current", as: "current_user"
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"

  get "/order/:id/confirmation", to: "orders#confirmation", as: "confirm_order"

  # May have to change this route 
  get "/users/:id/products/:id/orderitem_id"



end
