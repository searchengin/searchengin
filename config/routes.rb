require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: "users/registrations" }

  resources :users do
    collection do
      get :profile
    end
    member do
      patch :follow_user
      patch :unfollow_user
    end
  end
  resources :urls
  resources :news
  get 'dashboard/index'
  get '/@:id', to: 'dashboard#get_domain', as: :get_domain
  get 'dashboard/result'
  get 'dashboard/get_url_object/:id', to: 'dashboard#get_url_object', as: :get_url_object
  get 'dashboard/search', to: 'dashboard#search', as: :search
  post 'dashboard/like', to: 'dashboard#like', as: :like
  post 'dashboard/dislike', to: 'dashboard#dislike', as: :dislike
  post 'urls/tags', to: 'urls#tags', as: :tags
  post 'tags/create', to: 'tags#create', as: :create
  get 'dashboard/verify_domain/:id', to: 'dashboard#verify_domain', as: :verify_domain
  #get 'urls/url_details/:id', to: 'urls#url_details', as: :url_details


  root 'dashboard#index'


end
