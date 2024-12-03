Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  resources :tasks
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "static_pages#top"
  resources :users, only: %i[new create]
  resources :diaries, only: %i[index new create show edit destroy update] do 
  end  
  resource :profile, only: %i[show edit update]
  resources :password_resets, only: %i[new create edit update]

  get 'terms_of_service', to: 'informations#terms_of_service', as: :informations_terms_of_service
  get 'privacy_policy', to: 'informations#privacy_policy', as: :informations_privacy_policy
  get 'how_to_used', to: 'informations#how_to_used', as: :informations_how_to_used

  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
end
