class Owner::DashboardController < ApplicationController
  before_action :authenticate_admin!
  def index
    @total_orders = Order.where.not(status: [:refunded,:cancelled]).sum(&:total)
    @total_cancelled = Order.where(status: :cancelled).sum(&:total)
    @total_refunded = Order.where(status: :refunded).sum(&:total)
    @params_status = params[:status]

    @order_list = Order.where(status: @params_status)

   # get the total ordersales every day
   orders_data = Order.where(created_at: 1.month.ago.beginning_of_day..Time.zone.now.end_of_day).group_by_day(:created_at).sum(:total)

   # Prepare data for Chartkick
   @orders_data = []
   orders_data.each { |date, order_count| @orders_data << [ date, order_count ] }
  end
end
