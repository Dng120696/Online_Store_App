class Owner::OrdersController < ApplicationController

  def index
      puts params.inspect
      @orders = Order.order(:id).includes(:user)

  end


  def update
    @order = Order.find(params[:id])
    if @order.update(order_params)
        flash[:notice] = "Order status updated successfully!"

        logger.info "Order ##{@order.id} status updated via AJAX request."
        redirect_to owner_orders_path
    end
  end


  private
  def order_params
    params.require(:order).permit(:status)
  end
end
