require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  resources :urls
  resources :news
  get 'dashboard/index'
  get 'dashboard/get_url_object/:id', to: 'dashboard#get_url_object', as: :get_url_object
  get 'dashboard/search', to: 'dashboard#search', as: :search
  post 'dashboard/like', to: 'dashboard#like', as: :like
  post 'dashboard/dislike', to: 'dashboard#dislike', as: :dislike
  post 'urls/tags', to: 'urls#tags', as: :tags
  post 'tags/create', to: 'tags#create', as: :create


  root 'dashboard#index'


end
