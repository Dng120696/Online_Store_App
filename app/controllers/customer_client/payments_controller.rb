class CustomerClient::PaymentsController < ApplicationController


def index
  @cart_items = current_user&.cart&.cart_items || []
  @total_amount = calculate_total_amount(@cart_items)
  @payment_method = session[:payment_method]
end

private
def calculate_total_amount(cart_items)
  cart_items.sum { |item| (item.product.price || 0) * (item.quantity || 0) }
end
end
