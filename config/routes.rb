require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: "users/registrations", sessions: "users/sessions" }

  resources :users do
    collection do
      # get :profile
      post :post_status

    end
    member do
      patch :follow_user
      patch :unfollow_user
      patch :set_role
    end
  end
  resources :urls, except: [:show]
  resources :news
  get 'dashboard/index'
  # get '/@:id', to: 'dashboard#get_domain', as: :get_domain
  get '/@:id', to: 'users#profile', as: :profile
  get 'dashboard/result'
  get 'dashboard/get_url_object/:id', to: 'dashboard#get_url_object', as: :get_url_object
  get 'dashboard/search', to: 'dashboard#search', as: :search
  post 'dashboard/like', to: 'dashboard#like', as: :like
  post 'dashboard/dislike', to: 'dashboard#dislike', as: :dislike
  post 'urls/tags', to: 'urls#tags', as: :tags
  post 'tags/create', to: 'tags#create', as: :create
  get 'dashboard/verify_domain/:id', to: 'dashboard#verify_domain', as: :verify_domain
  get 'tags/verify_tags', to: 'tags#verify_tags', as: :verify_tags
  patch 'tags/tag_verification/:id', to: 'tags#tag_verification', as: :tag_verification
  #get 'urls/url_details/:id', to: 'urls#url_details', as: :url_details
  patch 'users/set_editor/:id', to: 'users#set_editor', as: :set_editor
  get '/:id', to: "urls#display_main_url"

  get 'e/:slug', to: 'urls#show', as: 'urls_show'


  root 'dashboard#index'


end
