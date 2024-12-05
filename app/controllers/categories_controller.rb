class CategoriesController < ApplicationController
  def index
    @products = Product.where(category_id: params[:category_id])
    @categories = Category.all

  end
end
