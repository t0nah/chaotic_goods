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

  def checkout
    @user = current_user || User.new
    @provinces = ["Ontario", "Quebec", "British Columbia", "Alberta"]
    @cart_items = current_cart.items
  end

  def create_order
    @user = current_user || User.find_or_create_by(email: params[:user][:email]) do |user|
      user.name = params[:user][:name]
      user.address = params[:user][:address]
      user.province = params[:user][:province]
  end

    # Tax calculation based on province
    tax_rates = {
      "Ontario" => { pst: 0.08, gst: 0.05 },
      "Quebec" => { pst: 0.0975, gst: 0.05 },
      "British Columbia" => { pst: 0.07, gst: 0.05 },
      "Alberta" => { pst: 0, gst: 0.05 }
    }
    selected_tax = tax_rates[@user.province]
    pst = selected_tax[:pst]
    gst = selected_tax[:gst]
    hst = pst + gst

    # Cart calculation
    cart_items = current_cart.items
    subtotal = cart_items.sum { |item| item.product.price * item.quantity }
    tax = subtotal * hst
    total_amount = subtotal + tax

    # Order creation
    order = Order.create!(
      user: @user,
      date: Time.now,
      order_amount: total_amount,
      status: "pending"
    )

    # Add items to the order
    cart_items.each do |cart_item|
      OrderItem.create!(
        order: order,
        product: cart_item.product,
        quantity: cart_item.quantity,
        price: cart_item.product.price
      )
    end
  end
end
