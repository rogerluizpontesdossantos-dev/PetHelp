Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      post "auth/register", to: "auth#register"
      post "auth/login", to: "auth#login"

      resources :pets, only: [:index, :show, :create, :update, :destroy] do
        member do
          post :mark_adopted
        end
      end

      resources :adoption_requests, only: [:index, :show, :create] do
        member do
          post :accept
          post :reject
          post :cancel
          post :complete
        end
      end

      resources :adoption_terms, only: [:show, :create] do
        member do
          post :sign
        end
      end

      resources :follow_ups, only: [:index, :show, :create, :update]

      resources :reviews, only: [:index, :create]

      resources :users, only: [:show, :update] do
        member do
          get :reputation
        end
      end
    end
  end
end
