class CustomerClient::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.includes(order_items: :product)
  end

# GET
  def confirmation
     @url = session[:checkout_url]

  end


  def success
    client = PaymongoAPI::V1::Client.new
    amount = session[:amount]
    src_id = session[:src_id]
    retrieved_source = client.retrieve_payment_source(src_id)

    if retrieved_source['data']['attributes']['status'] == 'chargeable'
      puts 'gcash'
    client.create_payment(amount, src_id)
    end
    puts 'card'
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
      end
          @cart.destroy
          session.delete(:amount)
          session.delete(:src_id)
          session.delete(:checkout_url)

          redirect_to customer_client_orders_path, notice: 'Order placed successfully.'
    end
  end

  def failed
    redirect_to customer_client_dashboard_index_path, alert: 'Payment failed! Please try again.'
  end
end
