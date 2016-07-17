Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :bucketlists, except: [:new, :edit] do
        resources :items, only: [:create, :update, :destroy]
      end
      post "/auth/login" => "sessions#create"
      get "/auth/logout" => "sessions#destroy"
    end
    resources :users, only: [:show, :create, :update, :destroy]
  end
  # match "*invalid_endpoint", to: "application#invalid_endpoint", via: :all
end
