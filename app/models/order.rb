class Order < ApplicationRecord
  belongs_to :users
  has_many :order_items
  has_many :products, through: :order_items



  enum status: {
    active: 0,
    abandoned: 1,
    cancelled: 2,
    paid: 3,
    shipped: 4,
    completed: 5
  }
end
