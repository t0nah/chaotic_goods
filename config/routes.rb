Rails.application.routes.draw do

  root "home#index"
  get '/products', to: 'products#index'
  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]

  devise_for :admins

  namespace :admin do
    root to: 'dashboard#index'
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    resources :products
    resources :categories
  end


end
