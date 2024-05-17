class Product < ApplicationRecord
  belongs_to :admin

  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :weight, presence: true, numericality: { greater_than: 0 }
  validates :categories, presence: true
  validates :description, presence: true
  validates :brand_id, presence: true
  validates :inventory_level, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
