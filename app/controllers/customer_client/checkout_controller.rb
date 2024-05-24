class CustomerClient::CheckoutController < ApplicationController
  def index

    @cart_items = current_user&.cart&.cart_items || []
    @total_amount = calculate_total_amount(@cart_items)
  end

# GET
  def process_checkout
    payment_method = params[:payment_method]
    session[:payment_method] = payment_method
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

  # POST
  def confirm_payment
      payment_method = params[:payment_method]
      client = PaymongoAPI::V1::Client.new
      amount = calculate_total_amount(current_user.cart.cart_items)

      success_url = "http://127.0.0.1:3000/customer_client/success"
      failed_url = "http://127.0.0.1:3000/customer_client/failed"
      user_address = current_user.addresses.first
      address_details =  {
        state: user_address&.state_or_province || 'Cagayan',
        postal_code: user_address&.zip_code ||  3519,
        city: user_address&.city || 'Tuguegarao',
        country: 'PH'
        }
      begin
        case payment_method
        when 'gcash'
          payment_method_details ={
              name: params[:name],
              email: params[:email],
              phone: params[:phone],
              address: address_details
          }

          payment_sources = client.create_payment_source(amount,'gcash',success_url,failed_url,billing_details: payment_method_details)
          checkout_url = payment_sources['data']['attributes']['redirect']['checkout_url']
          status = payment_sources["data"]["attributes"]["status"]

          if status == "pending"
            session[:checkout_url] = checkout_url

            session[:amount] = payment_sources["data"]["attributes"]["amount"]
            session[:src_id] = payment_sources["data"]["id"]
           redirect_to customer_client_order_confirmation_path
          end

        when 'card'
          intent_response = client.create_payment_intent(amount, 'PHP')
          card_details = {
            card_number: params[:number].gsub(/\s+/, "") ,
            exp_month: params[:exp_month].to_i,
            exp_year: params[:exp_year].to_i,
            cvc: params[:cvc]
          }


          payment_method_response = client.create_payment_method_card(card_details,address_details,current_user)

          payment_intent_id = intent_response['data']['id']
          client_key = intent_response['data']['attributes']['client_key']
          payment_method_id = payment_method_response['data']['id']
          attach_res = client.attach_payment_method_to_intent(payment_intent_id,client_key,payment_method_id,success_url)
          if attach_res["data"]["attributes"]["status"] == 'succeeded'
            redirect_to customer_client_success_path
          else
            redirect_to customer_client_failed_path
          end
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
