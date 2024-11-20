class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
  end

  def dashboard
    @products = Product.all
  end

  def show
    @products = Product.find(params[:id])
  end

  def new
    @products = Product.new
  end

  def create
    @products = Product.new(product_params)

    if @products.save
      redirect_to @products
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @products = Product.find(params[:id])
  end

  def update
    @products = Product.find(params[:id])

    if @products.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def product_params
      params.expect(product: [:title, :body])
    end
end
