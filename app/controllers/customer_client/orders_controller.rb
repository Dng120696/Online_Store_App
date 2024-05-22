class CustomerClient::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.includes(order_items: :product)
  end



  def confirmation
     @url = session[:paymongo_url]
    p @url
  end
end
