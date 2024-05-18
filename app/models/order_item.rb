class OrderItem < ApplicationRecord
  belongs_to :order
  belogs_to :product
end
