class Admin::ProductController < ApplicationController
  before_action :authenticate_admin!

  def new
    @product = Product.new
  end

end
