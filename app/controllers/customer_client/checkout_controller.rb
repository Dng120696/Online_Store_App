class CustomerClient::CheckoutController < ApplicationController
  before_action :authenticate_user!
  def index;  end

  def load_checkout
    @cart = current_user&.cart
    if @cart
      @cart_items = @cart.cart_items.includes(product: { image_attachment: :blob }) # Include product to avoid N+1 queries
    else
      @cart_items = []
    end
    @total_amount = calculate_total_amount(@cart_items)

    render partial: 'load_checkout'
  end
  # GET
  def process_checkout
    payment_method = params[:payment_method]
    session[:payment_method] = payment_method
    redirect_to customer_client_payments_path
  end

  # POST
  def confirm_payment
    payment_method = params[:payment_method]
    client = PaymongoAPI::V1::Client.new
    amount = calculate_total_amount(current_user.cart.cart_items)

    success_url = "http://127.0.0.1:3000/customer_client/success"
    failed_url = "http://127.0.0.1:3000/customer_client/failed"
    shipping_address = current_user.shipping_addresses.find(session[:shipping_address_id])
    p shipping_address
    address_details = {
      state: shipping_address&.state_or_province || 'Cagayan',
      postal_code: shipping_address&.zip_code || 3519,
      city: shipping_address&.city || 'Tuguegarao',
      country: 'PH'
    }

    begin
      case payment_method
      when 'gcash'
        payment_method_details = {
          name: params[:name],
          email: params[:email],
          phone: params[:phone],
          address: address_details
        }

        payment_sources = client.create_payment_source(amount, 'gcash', success_url, failed_url, billing_details: payment_method_details)
        @checkout_url = payment_sources['data']['attributes']['redirect']['checkout_url']
        status = payment_sources["data"]["attributes"]["status"]

        if status == "pending"
          session[:checkout_url] =  @checkout_url
          session[:amount] = payment_sources["data"]["attributes"]["amount"]
          session[:src_id] = payment_sources["data"]["id"]

            redirect_to customer_client_order_confirmation_path
        end

      when 'card'
        intent_response = client.create_payment_intent(amount, 'PHP')
        card_details = {
          card_number: params[:number],
          exp_month: params[:exp_month].to_i,
          exp_year: params[:exp_year].to_i,
          cvc: params[:cvc]
        }

        payment_method_response = client.create_payment_method_card(card_details, address_details, current_user)

        payment_intent_id = intent_response['data']['id']
        client_key = intent_response['data']['attributes']['client_key']
        payment_method_id = payment_method_response['data']['id']
        attach_res = client.attach_payment_method_to_intent(payment_intent_id, client_key, payment_method_id, success_url)

        payment_lists = client.payment_lists

        get_payment_id = payment_lists["data"].select { |payment_list| payment_list["attributes"]["payment_intent_id"] == payment_intent_id }.first["id"]
        session[:card_payment_id] = get_payment_id


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

  def update_address
    address_id = params[:address_id]
    session[:comment] = params[:comment][:body]

    if address_id == 'new'
      new_address = current_user.shipping_addresses.create(address_params)
      if new_address.persisted?
        session[:shipping_address_id] = new_address.id
      else
        flash[:error] = new_address.errors.full_messages.join(", ")
        redirect_to customer_client_checkout_index_path and return
      end
    else
      session[:shipping_address_id] = address_id
    end

    redirect_to customer_client_payments_path
  end

  private

  def address_params
    params.require(:shipping_address).permit(:street, :city, :state_or_province, :zip_code,:country)
  end

  def calculate_total_amount(cart_items)
    cart_items.sum { |item| (item.product.price || 0) * (item.quantity || 0) }
  end
end
