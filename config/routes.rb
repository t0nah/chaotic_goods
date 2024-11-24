Rails.application.routes.draw do

  root "products#index"
  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]

  devise_for :admins

  get 'admin_dashboard', to: 'admins#dashboard'
  get 'admin_product', to: 'admin#product'

  namespace :admin do
    root to: 'dashboard#index'
    resources :products, :categories
    resources :product
  end


end
