# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/home", to: "static_pages#home"
    get "/contact", to: "static_pages#contact"
    get "/about", to: "static_pages#about"
    get "/admin", to: "admin/admin_pages#index"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/search", to: "searchs#index"

    resources :orders, only: %i(new create)
    resources :users
    resources :cart
    namespace :admin do
      resources :categories
      resources :products
    end
  end
end
