class Owner::DashboardController < ApplicationController
  before_action :authenticate_admin!
  def index
   # get the total ordersales every day
   orders_data = Order.where(created_at: 1.months.ago..Date.today).group_by_day(:created_at).sum(:total)

   # Prepare data for Chartkick
   @orders_data = []
   orders_data.each { |date, order_count| @orders_data << [ date, order_count ] }
  end
end
