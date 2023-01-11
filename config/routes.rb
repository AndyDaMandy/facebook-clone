Rails.application.routes.draw do
  #resources :posts
  devise_for :users
  resources :posts do
    resources :comments
    resources :likes
  end
  resources :users do
    resources :profile
    resources :comments
    resources :likes
    resources :friendship
  end
  resources :users, :only => [:show]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "posts#index"
end
