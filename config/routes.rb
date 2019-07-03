# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    # devise_for :users
    devise_for :users, controllers: {
      registrations: "users/registrations"
    }
    devise_scope :user do
      get "/login", to: "devise/sessions#new"
      post "/login", to: "devise/sessions#create"
      delete "/logout", to: "devise/sessions#destroy"
      get "/signup", to: "devise/registrations#new"
    end

    get "/home", to: "static_pages#home"
    get "/contact", to: "static_pages#contact"
    get "/about", to: "static_pages#about"
    get "/admin", to: "admin/admin_pages#index"
    get "/search", to: "searchs#index"
    get "/history-orders", to: "history_orders#index"

    resources :comments, only: %i(create destroy)
    resources :rates, only: %i(create destroy)
    resources :notifications, only: %i(index update)
    resources :orders, only: %i(new create show)
    resources :cart, only: %i(index create update)
    delete "cart_destroy", to: "cart#destroy"
    resources :users, only: %i(show)
    resources :requests
    resources :products, only: %i(index show)
    get "/shop", to: "products#index"
    resources :item_photos, only: :destroy
    namespace :admin do
      resources :categories, except: :show
      resources :products do
        collection do
          post :import
          get :export
        end
      end
      resources :orders, only: %i(index update)
      resources :requests, only: %i(index update destroy)
      resources :charts, only: %i(index)
      resources :users
      resources :schedules, only: %i(index create destroy)
    end
  end
end
