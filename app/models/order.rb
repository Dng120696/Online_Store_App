class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items
  has_one :comment


  enum status: {
    pending: 0,
    cancelled: 1,
    paid: 2,
    shipped: 3,
    completed: 4
  }
end
