class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_one :comment


  enum status: {
    pending: 0,
    cancelled: 1,
    refunded:2,
    shipped: 3,
    received:4,
    completed:5
  }
end
