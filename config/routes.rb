Rails.application.routes.draw do
  get 'pages/privacy'
  #resources :posts
  #devise_for :users
  #devise_for :users, controllers: { registrations: "registrations" }
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
  root 'posts#index'
=begin
  authenticated :user do
    root 'posts#index', as: 'authenticated_root'
  end
  devise_scope :user do
    root 'devise/sessions#new'
  end
=end
  resources :posts do
    resources :comments
    resources :likes
    member do
      delete :delete_images
    end
  end
  get "/privacy", to: "pages#privacy"
  get '/self_posts', to: 'posts#self_posts'
  get '/friend_posts', to: 'posts#friend_posts'
  get '/user_posts', to: 'posts#user_posts'
  resources :users do
    resources :profile
    resources :comments
    resources :likes
    collection do
      get 'search'
    end
  end

  resources :friendships
  get 'friends/create/:id', to: 'friendships#create', as: 'add_friend'
  resources :authentications, only: [:destroy]
  resources :users, :only => [:show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  #root "posts#index"
end
