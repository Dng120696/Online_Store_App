class CustomerClient::ReviewsController < ApplicationController

  def create
    p params
    @review = Review.new(params.require(:review).permit(:user_id,:product_id,:rating,:comment))
    if @review.save
      redirect_to customer_client_orders_path, notice: 'Added reviews to product order successfully'
    else
      redirect_to customer_client_orders_path, alert: 'Failed to add reviews to product order'
    end
  end
end
