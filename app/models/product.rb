class Product < ApplicationRecord
  belongs_to :admin
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_many :cart_items, dependent: :destroy
  has_many :cart, through: :cart_items
  has_one_attached :image

  validates_presence_of :weight,:categories,:brand, :description

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :inventory_level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
