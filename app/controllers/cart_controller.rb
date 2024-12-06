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
    @cart_items = session[:cart] || []
    @provinces = [ "Ontario", "Quebec", "British Columbia", "Alberta" ]

    # Tax rates by province
    @tax_rates = {
      "Ontario" => { pst: 0.08, gst: 0.05 },
      "Quebec" => { pst: 0.0975, gst: 0.05 },
      "British Columbia" => { pst: 0.07, gst: 0.05 },
      "Alberta" => { pst: 0, gst: 0.05 }
    }

    calculate_totals
  end

  def create_order
    @user = current_user || User.create!(user_params)
    @cart_items = session[:cart] || []

    # Calculate total
    subtotal = @cart_items.sum { |id| Product.find(id).price }
    taxes = subtotal * (@hst || 0)
    total_amount = subtotal + taxes

    # Create order
    order = Order.create!(
      user: @user,
      order_amount: total_amount,
      status: "pending",
      date: Time.now
    )

    # Create order items
    @cart_items.each do |product_id|
      product = Product.find(product_id)
      OrderItem.create!(order: order, product: product, quantity: 1, price: product.price)
    end

    # Clear cart
    session[:cart] = []
    redirect_to order_path(order), notice: "Order created successfully!"
  end

  private

  def user_params
    params.require(:user).permit(:name, :address, :province)
  end

  def calculate_totals
    if @user.province.present?
      selected_tax = @tax_rates[@user.province]
      @pst = selected_tax[:pst]
      @gst = selected_tax[:gst]
      @hst = @pst + @gst
      @subtotal = @cart_items.sum { |id| Product.find(id).price }
      @tax = @subtotal * @hst
      @total_amount = @subtotal + @tax
    else
      @subtotal = @tax = @total_amount = 0
    end
  end
end
