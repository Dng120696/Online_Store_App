class Cart < ApplicationRecord
  belongs_to :users

  enum status: {
    active: 0,
    abandoned: 1,
    cancelled: 2,
    paid: 3,
    shipped: 4,
    completed: 5
  }
end
