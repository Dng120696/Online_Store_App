class CustomerClient::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.all
    @cart = current_user.cart
    if @cart
      @cart_items = @cart.cart_items.includes(:product) # Include product to avoid N+1 queries
    else
      @cart_items = []
    end
  end

end
