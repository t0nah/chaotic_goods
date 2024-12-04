class CartsController < ApplicationController
  before_action :initialize_cart

  # Display the cart contents
  def show
    @cart_items = @cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      { product: product, quantity: quantity } if product
    end.compact
  end

  # Add a product to the cart
  def add
    product_id = params[:id]

    # Ensure the product is not already in the cart (one-of-a-kind constraint)
    if @cart[product_id]
      redirect_to cart_path, alert: 'This product is already in your cart.'
    else
      @cart[product_id] = 1
      session[:cart] = @cart
      redirect_to cart_path, notice: 'Product added to cart!'
    end
  end

  # Remove a product from the cart
  def remove
    @cart.delete(params[:id])
    session[:cart] = @cart
    redirect_to cart_path, notice: 'Product removed from cart!'
  end

  # Update the quantity of a product in the cart (for future extensibility)
  def update_quantity
    product_id = params[:id]
    new_quantity = params[:quantity].to_i

    if @cart[product_id] && new_quantity.positive?
      @cart[product_id] = new_quantity
      session[:cart] = @cart
      redirect_to cart_path, notice: 'Cart updated!'
    else
      redirect_to cart_path, alert: 'Invalid quantity or product not in cart.'
    end
  end

  private

  # Initialize the cart from the session or create a new one
  def initialize_cart
    @cart = session[:cart] || {}
  end
end
