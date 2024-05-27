class CustomerClient::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.includes(order_items: :product)
  end

# GET
  def confirmation
     @url = session[:checkout_url]
  end

  #GET
  def success
    ActiveRecord::Base.transaction do
    client = PaymongoAPI::V1::Client.new
    order_comment = session[:comment]
    p order_comment
    amount = session[:amount]
    src_id = session[:src_id]
    payment_method  = session[:payment_method]

    if payment_method == 'gcash'
      retrieved_source = client.retrieve_payment_source(src_id)
      status = retrieved_source['data']['attributes']['status']

      if status == 'chargeable'
        client.create_payment(amount, src_id)
      end
    end

    @cart_items = current_user.cart.cart_items
    @total_amount =  @cart_items.sum { |item| (item.product.price) * item.quantity }
    @cart = current_user.cart
    @order = Order.new(user_id: current_user.id)
    @order.total = @cart&.cart_items.sum { |item| item.product.price * item.quantity }

    if @order.save
          @cart.cart_items.each do |cart_item|
        @order.order_items.create(
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
        Comment.create(order_id:@order[:id],body:order_comment)
      end
          @cart.destroy
          session.delete(:amount)
          session.delete(:src_id)
          session.delete(:checkout_url)
          session.delete(:payment_method)
          session.delete(:comment)
          session.delete(:shipping_address_id)
          redirect_to customer_client_orders_path, notice: 'Order placed successfully.'
      end
    end
  end

  #GET
  def failed
    redirect_to customer_client_dashboard_index_path, alert: 'Payment failed! Please try again.'
  end
end
