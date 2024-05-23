class Owner::OrdersController < ApplicationController
  before_action :authenticate_admin!
  def index
      @orders = Order.includes(order_items: :product).all
      p @orders
  end
  def search_user
    session[:search_user] = params[:search]
    redirect_to new_owner_order_path
  end

  def new
    @user = User.find_by(email: session[:search_user])
    @order = Order.new(user: @user)
  end

  def create
    @order = Order.new(order_params)
  end

  private

def order_params
  params.require(:order).permit(:user_id,:status, :total)
end
end
