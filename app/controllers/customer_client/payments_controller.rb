class CustomerClient::PaymentsController < ApplicationController


def index
  @cart = current_user&.cart
  if @cart
    @cart_items = @cart.cart_items.includes(product: { image_attachment: :blob }) # Include product to avoid N+1 queries
  else
    @cart_items = []
  end
  @total_amount = calculate_total_amount(@cart_items)
  @payment_method = session[:payment_method]
end

private
def calculate_total_amount(cart_items)
  cart_items.sum { |item| (item.product.price || 0) * (item.quantity || 0) }
end
end
