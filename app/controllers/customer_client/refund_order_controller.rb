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

    if @order.update(status: :refunded)
      UserMailer.notify_order_refunded(@user).deliver_later
       redirect_to customer_client_orders_path(status: 'refunded'), notice: 'Order successfully refunded.'
    end
  end
end
