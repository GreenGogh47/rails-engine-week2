Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers, only: [:index]
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "merchant/items"
      end
      resources :items, only: [:index, :show]
    end
  end
end
