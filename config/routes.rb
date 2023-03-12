Rails.application.routes.draw do
  get 'pages/privacy'
  #resources :posts
  #devise_for :users
  #devise_for :users, controllers: { registrations: "registrations" }
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
  authenticated :user do
    root 'posts#index', as: 'authenticated_root'
  end
  devise_scope :user do
    root 'devise/sessions#new'
  end
  resources :posts do
    resources :comments
    resources :likes
  end
  get '/self_posts', to: 'posts#self_posts'
  resources :users do
    resources :profile
    resources :comments
    resources :likes
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
