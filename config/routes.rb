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
    get "/history-orders", to: "history_orders#index"
    post "/rates", to: "rates#create"
    post "/comments", to: "comments#create"

    resources :orders, only: %i(new create)
    resources :cart, only: %i(index create update)
    delete "cart_destroy", to: "cart#destroy"
    resources :users
    resources :requests
    get "/signup", to: "users#new"
    resources :products, only: %i(index show)
    get "/shop", to: "products#index"
    resources :item_photos, only: :destroy
    namespace :admin do
      resources :categories, except: :show
      resources :products do
        collection { post :import }
      end
      resources :orders, only: %i(index update)
      resources :requests, only: %i(index update destroy)
      resources :charts, only: %i(index)
      resources :schedules, only: %i(index create destroy)
    end
  end
end
