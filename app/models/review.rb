class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product, counter_cache: true
  after_save :update_product_rating
  after_destroy :update_product_rating

  private

  def update_product_rating
    product.update(
      average_rating: product.reviews.average(:rating).to_f,
      reviews_count: product.reviews.size
    )
  end
end
