class Category < ApplicationRecord
  belongs_to :admin
  has_many :product_categories
  has_many :products, through: :product_categories
end
