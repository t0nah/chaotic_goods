class CartController < ApplicationController
  def add
    # Initialize cart in the session if it doesn't exist
    session[:cart] ||= []

    # Add the product ID to the cart
    session[:cart] << params[:product_id]

    redirect_to products_path, notice: "Product added to cart."
  end

  def index
    # Fetch product details for all items in the cart
    @cart_products = Product.where(id: session[:cart])
    @categories = Category.all

  end
end
