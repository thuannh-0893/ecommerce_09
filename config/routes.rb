# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/home", to: "static_pages#home"
    get "/contact", to: "static_pages#contact"
    get "/about", to: "static_pages#about"
    get "/search", to: "static_pages#search"
    get "/admin", to: "admin/admin_pages#index"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/search", to: "searchs#index"

    resources :orders, only: %i(new create)
    resources :cart
    resources :users
    get "/signup", to: "users#new"
    resources :products
    get "/shop", to: "products#index"
    resources :item_photos, only: :destroy
    namespace :admin do
      resources :categories, except: :show
      resources :products
    end
  end
end
