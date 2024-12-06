class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "Product was successfully updated."
      redirect_to admin_products_path
    else
      flash.now[:alert] = "Failed to update product. Please fix the errors below."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      Rails.logger.info("Product #{@product.id} deleted successfully.")
      redirect_to admin_products_path, notice: "Product was successfully deleted."
    else
      Rails.logger.error("Failed to delete product #{@product.id}.")
      redirect_to admin_products_path, alert: "Failed to delete the product."
    end
  rescue StandardError => e
    Rails.logger.error("Error during deletion: #{e.message}")
    redirect_to admin_products_path, alert: "An unexpected error occurred."
  end


  private

  def set_product
    @product = Product.find(params[:id]) # Singular instance variable for a single product
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :category_id, :image)
  end
end
