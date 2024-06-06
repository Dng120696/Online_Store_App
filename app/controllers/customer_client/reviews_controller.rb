class CustomerClient::ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    p params
    @review = Review.new(params.require(:review).permit(:user_id,:product_id,:rating,:comment))
    if @review.save
      redirect_to customer_client_orders_path(status: 'completed'), notice: 'Added reviews to product order successfully'
    else
      redirect_to customer_client_orders_path(status: 'completed'), alert: 'Failed to add reviews to product order'
    end
  end
end
