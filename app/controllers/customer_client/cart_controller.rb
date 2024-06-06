class CustomerClient::CartController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def load_cart
    @cart = current_user.cart
    if @cart
      @cart_items = @cart.cart_items.includes(product: { image_attachment: :blob }) # Include product to avoid N+1 queries
    else
      @cart_items = []
    end
    render partial: 'cart'
  end

end
