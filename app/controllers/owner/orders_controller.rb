class Owner::OrdersController < ApplicationController

  def index
      puts params.inspect
      @orders = Order.includes(order_items: :product).all

  end


  def update_status
    @order = Order.find(params[:id])
    if @order.update(order_params)
      redirect_to owner_orders_path, notice: 'Order was successfully updated'

    end
  end


  private
  def order_params
    params.require(:order).permit(:status)
  end
end
