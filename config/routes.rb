Rails.application.routes.draw do
  get "category/index"
  get "product/index"
  devise_for :admins
  get 'admin_dashboard', to: 'admins#dashboard'

  namespace :admin do
    root to: 'dashboard#index'
    resources :products, :categories
  end

  root "product#index"
  resources :products, only: [:index, :show]
end
