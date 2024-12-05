class ProductsController < ApplicationController
  def index
    @products = Product.all
    @categories = Category.all
    @products = @products.page(params[:page]).per(10)

    # Filter by keyword if provided
    if params[:search].present?
      @products = @products.where("name LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    end

    # Filter by category if provided
    if params[:category_id].present? && params[:category_id] != "all"
      @products = @products.where(category_id: params[:category_id])
    end
  end

  def show
    @products = Product.find(params[:id])
    @categories = Category.all
  end

  def search
    redirect_to products_path(search: params[:search], category_id: params[:category_id])
  end
end