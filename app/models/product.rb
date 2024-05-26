class Product < ApplicationRecord
  belongs_to :admin
  has_many :product_categories
  has_many :categories, through: :product_categories
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :order_items
  has_many :orders, through: :order_items
  has_many :cart_items
  has_many :cart, through: :cart_items
  has_one_attached :image

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :categories, presence: true
  validates :description, presence: true
  validates :brand_id, presence: true
  validates :inventory_level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
