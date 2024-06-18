class CustomerClient::CartController < ApplicationController
  include GetCartItems
  before_action :authenticate_user!

  def index; end

  def load_cart
    get_cart_items()
    render partial: 'cart'
  end

end
