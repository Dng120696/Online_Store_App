class CustomerClient::DashboardController < ApplicationController

  def index
    @products = Product.all.includes(image_attachment: :blob).order("inventory_level DESC")
    @cart = current_user&.cart
    if @cart
      @cart_items = @cart.cart_items.includes(product: { image_attachment: :blob }) # Include product to avoid N+1 queries
    else
      @cart_items = []
    end
  end

end
