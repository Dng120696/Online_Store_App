class CustomerClient::CheckoutController < ApplicationController
  def index

    @cart_items = current_user&.cart&.cart_items || []
    @total_amount = calculate_total_amount(@cart_items)
  end
  def calculate_total_amount(cart_items)
    # Logic to calculate total amount based on cart items
    # Example:
    cart_items.sum { |item| item.product.price * item.quantity }

  end

  def process_checkout
    payment_method = params[:payment_method]
    case payment_method
    when 'gcash'
      redirect_to customer_client_gcash_payment_path
    when 'card'
      redirect_to customer_client_card_payment_path
    else
      # Handle invalid or missing payment method
      flash[:error] = 'Please select a valid payment method.'
      redirect_to customer_client_checkout_index_path
    end
  end

  def confirm_payment
      payment_method = params[:payment_method]
      client = PaymongoAPI::V1::Client.new
      amount = calculate_total_amount(current_user.cart.cart_items)

      begin
        case payment_method
        when 'gcash'
          intent_response = client.create_payment_intent(amount, 'PHP')
          payment_method_details ={
              name: params[:name],
              email: params[:email],
              phone: params[:phone]
          }
          payment_method_response = client.create_payment_method_gcash(payment_method_details)

          payment_intent_id = intent_response['data']['id']
          client_key = intent_response['data']['attributes']['client_key']
          payment_method_id = payment_method_response['data']['id']
            return_url = "http://127.0.0.1:3000/customer_client/orders"
          attach_response = client.attach_payment_method_to_intent(payment_intent_id,client_key,payment_method_id,return_url)

          redirect_url = attach_response['data']['attributes']['next_action']['redirect']['url']
          @cart_items = current_user.cart.cart_items
          @total_amount = calculate_total_amount(@cart_items)
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
            redirect_to customer_client_order_confirmation_path, notice: 'Order placed successfully.'
          else
            redirect_to customer_client_cart_index_path, alert: 'Unable to place order.'
          end
          session[:paymongo_url] = redirect_url

        when 'card'
          intent_response = client.create_payment_intent(amount, 'PHP')
          card_details = {
            card_number: params[:number].gsub(/\s+/, "") ,
            exp_month: params[:exp_month].to_i,
            exp_year: params[:exp_year].to_i,
            cvc: params[:cvc]
          }
          payment_method_response = client.create_payment_method_card(card_details)

          payment_intent_id = intent_response['data']['id']
          client_key = intent_response['data']['attributes']['client_key']
          payment_method_id = payment_method_response['data']['id']
          return_url = "http://127.0.0.1:3000/customer_client/orders"
          client.attach_payment_method_to_intent(payment_intent_id,client_key,payment_method_id,return_url)

        else
          flash[:error] = 'Please select a valid payment method.'
          redirect_to customer_client_checkout_index_path and return
        end

      rescue StandardError => e
        flash[:error] = "Payment processing error: #{e.message}"
        p "Payment processing error: #{e.message}"
        redirect_to customer_client_checkout_index_path
      end
    end

    private

    def calculate_total_amount(cart_items)
      cart_items.sum { |item| (item.product.price) * item.quantity }
    end

end
