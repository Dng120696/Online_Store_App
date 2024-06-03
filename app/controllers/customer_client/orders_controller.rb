class CustomerClient::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders_queries = current_user.orders.includes(:comment,order_items: {product: { image_attachment: :blob }})
    pending_orders = @orders_queries.where(status: :pending).where.not(status: :cancelled)


    shipped_orders = pending_orders.where(created_at: 24.hours.ago..12.hours.ago)
    received_orders = pending_orders.where(created_at: 2.days.ago..24.hours.ago)
    completed_orders = pending_orders.where('created_at <= ?', 2.days.ago)

    shipped_orders.update_all(status: :shipped)
    received_orders.update_all(status: :received)
    completed_orders.update_all(status: :completed)

    if  params[:status] == 'recent'
      @orders = @orders_queries.where('created_at >= ?', 12.hours.ago).where.not(status: :cancelled)

    elsif params[:status].present?
      @orders = @orders_queries.where(status: params[:status]).order(:id)
    else
      @orders = @orders_queries.order(:id)
    end

  end
  def order_success; end

  def order_failed;  end

# GET
  def confirmation
     @url = session[:checkout_url]
  end

  #GET
  def success
    ActiveRecord::Base.transaction do
    client = PaymongoAPI::V1::Client.new
    payment_method  = session[:payment_method]
    order_comment = session[:comment]
    card_payment_id = session[:card_payment_id]
    amount = session[:amount]
    src_id = session[:src_id]

    if payment_method == 'gcash'
      retrieved_source = client.retrieve_payment_source(src_id)
      status = retrieved_source['data']['attributes']['status']
      p retrieved_source
      if status == 'chargeable'
        gcash_payment = client.create_payment(amount, src_id)
      end
    end


    @cart_items = current_user.cart.cart_items
    @total_amount =  @cart_items.sum { |item| (item.product.price) * item.quantity }
    @cart = current_user.cart
    @order = Order.new(user_id: current_user.id, payment_id: payment_method == "card" ? card_payment_id : gcash_payment["data"]["id"] )
    @order.total = @cart&.cart_items.sum { |item| item.product.price * item.quantity }

    if @order.save
         @cart.cart_items.each do |cart_item|
            @order.order_items.create(
              product: cart_item.product,
              quantity: cart_item.quantity,
              price: cart_item.product.price
            )
        end
        @order.order_items.each do |order_item|
            order_item.product.update!(inventory_level:order_item.product.inventory_level - order_item.quantity )

        end


          Comment.create(order_id:@order[:id],body:order_comment)
          @cart.destroy
          session.delete(:amount)
          session.delete(:src_id)
          session.delete(:checkout_url)
          session.delete(:payment_method)
          session.delete(:comment)
          session.delete(:shipping_address_id)
          session.delete(:card_payment_id)
          redirect_to order_success_customer_client_orders_path, notice: 'Order placed successfully.'
      end
    end
  end

  #GET
  def failed
    redirect_to customer_client_dashboard_index_path(category:params[:category],search:params[:search]), alert: 'Payment failed! Please try again.'
  end

  private
  def calculate_total_amount(cart_items)
    cart_items.sum { |item| (item.product.price || 0) * (item.quantity || 0) }
  end
end
