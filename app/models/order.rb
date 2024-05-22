class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items



  enum status: {
    pending: 0,
    abandoned: 1,
    cancelled: 2,
    paid: 3,
    shipped: 4,
    completed: 5
  }
end
