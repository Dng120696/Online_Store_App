module CalculateAmount
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private
  def calculate_total_amount(cart_items)
    cart_items.sum { |item| (item.product.price || 0) * (item.quantity || 0) }
  end
end
