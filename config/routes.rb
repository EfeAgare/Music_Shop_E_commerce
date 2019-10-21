Rails.application.routes.draw do
  resources :line_items
  resources :carts
  resources :instruments
  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  root 'instruments#index'

  resources :checkouts, only: [:create, :show]

  get "/checkouts/new/:id", to: "checkouts#new",  as: "cart_checkout"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
