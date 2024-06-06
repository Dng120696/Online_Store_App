class CustomerClient::RefundOrderController < ApplicationController
  before_action :authenticate_user!

  def refund
    client = PaymongoAPI::V1::Client.new
    @order = Order.find(params[:id])
    amount = params[:amount]
    reason = params[:reason]
    notes = params[:notes]
    client.refund_payment(amount,notes,reason,@order.payment_id)
    @user = current_user

    if @order.update(status: :cancelled)
      UserMailer.notify_order_refunded(@user, @order).deliver_later
       redirect_to customer_client_orders_path(status: 'cancelled'), notice: 'Order cancelled  successfully'
    end
  end
end
