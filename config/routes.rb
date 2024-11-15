Rails.application.routes.draw do
  get "category/index"
  get "product/index"
  devise_for :admins

  namespace :admin do
    root to: 'dashboard#index'
    resources :products, :categories
  end

  root "products#index"
  resources :products, only: [:index, :show]
end
