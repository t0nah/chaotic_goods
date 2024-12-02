class ProductsController < ApplicationController
  def index
    @products = Product.all
    @categories = Category.all
    @products = Kaminari.paginate_array(@products).page(params[:page]).per(10)
  end

  def show
    @products = Product.find(params[:id])
  end

end