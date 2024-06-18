module GetCartItems
  extend ActiveSupport::Concern

  def get_cart_items
    @cart = current_user&.cart
    @cart_items = @cart ? @cart.cart_items.includes(product: { image_attachment: :blob }) : []
  end
end
