class Owner::DashboardController < ApplicationController
  before_action :authenticate_admin!
  def index
   # get the total ordersales every day
   orders_data = Order.where(created_at: 1.months.ago..Date.today).group_by_day(:created_at).sum(:total)

   # Prepare data for Chartkick
   @orders_data = []
   orders_data.each { |date, order_count| @orders_data << [ date, order_count ] }
  end


  def approve
    user = User.find(params[:id])

    if user&.update(status: :approved)
      UserMailer.approved_user_registration(user).deliver_later
      redirect_to owner_dashboard_index_path, notice: "User account approved successfully"
    else
      redirect_to owner_dashboard_index_path, alert: "Unable to approve user account"
    end

  end
end
