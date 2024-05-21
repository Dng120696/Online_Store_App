class Cart < ApplicationRecord
  belongs_to :users
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  enum status: {
    active: 0,
    abandoned: 1,
    cancelled: 2,
    paid: 3,
    shipped: 4,
    completed: 5
  }
end
