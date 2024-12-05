Rails.application.routes.draw do

  root "home#index"
  get '/products', to: 'products#index'
  resources :products, only: [:index, :show] do
    collection do
      get 'search'
    end
  end
  resources :categories, only: [:index, :show]
  resources :pages, only: [:show]

  post 'cart/add/:product_id', to: 'cart#add', as: 'cart_add'
get 'cart', to: 'cart#index', as: 'cart_index'

  devise_for :admins

  namespace :admin do
    root to: 'dashboard#index'
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    resources :products
    resources :categories
    resources :pages, only: [:edit, :update]

  end
end
