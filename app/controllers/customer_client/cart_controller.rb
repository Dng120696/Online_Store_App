class CustomerClient::CartController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart = current_user.cart
  end

end
