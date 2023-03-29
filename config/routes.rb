Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers, only: [:index]
      get "merchants/find_all", controller: "merchant/search"
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "merchant/items"
      end
      get "items/find", controller: "item/search", action: "show"
      resources :items, only: [:index, :show, :create, :update, :destroy] do
        resources :merchant, only: [:index], controller: "item/merchant"
      end
    end
  end
end
