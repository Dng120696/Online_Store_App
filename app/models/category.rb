class Category < ApplicationRecord
  belongs_to :admin
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories

  validates_presence_of :title

end
