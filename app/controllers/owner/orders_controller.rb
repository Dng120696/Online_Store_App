class Owner::OrdersController < ApplicationController

  def index
      puts params.inspect
      @orders = Order.includes(order_items: :product).all

  end


  def update_status
    @order = Order.find(params[:id])

    if @order.update(order_params)
      render json: { message: 'Order status updated successfully' }, status: :ok
    else
      # Log errors for debugging
      Rails.logger.error @order.errors.full_messages.join(', ')
      render json: { errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private
  def order_params
    params.require(:order).permit(:status)
  end
end
