class CustomerClient::PaymentsController < ApplicationController
  include CalculateAmount
  include GetCartItems
  def index; end

  def load_payment
    get_cart_items()
    @total_amount = calculate_total_amount(@cart_items)
    @payment_method = session[:payment_method]

    render partial: 'load_payment'
  end

end
