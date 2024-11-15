class CategoryController < ApplicationController
  def index
    @products = Product.where(category_id: params[:category_id])
  end
end
