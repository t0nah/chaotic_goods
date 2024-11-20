Rails.application.routes.draw do
  get "category/index"
  get "product/index"
  devise_for :admins
  get 'admin_dashboard', to: 'admins#dashboard'
  get 'admin_product', to: 'admin#product'

  namespace :admin do
    root to: 'dashboard#index'
    resources :products, :categories
    resources :product
  end

  root "product#index"
  resources :products, only: [:index, :show]
end
