class CustomerClient::OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = current_user.cart
  end

  def create
    @cart = current_user.cart

  end

  def show

  end

  def confirmation


  end
end
