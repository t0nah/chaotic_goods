class ProductsController < ApplicationController
  def index
    @products = Product.all
    @categories = Category.all
    @products = @products.page(params[:page]).per(10)
  end

  def show
    @products = Product.find(params[:id])
  end

end