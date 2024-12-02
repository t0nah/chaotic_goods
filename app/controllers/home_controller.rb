class HomeController < ApplicationController
  def index
    @products = Product.limit(5)
    @categories = Category.all
  end
end
