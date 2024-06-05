class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, counter_cache: true

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_create :update_product_order_items_count

  private

  def update_product_order_items_count
    product.update_order_items_count
  end
end
