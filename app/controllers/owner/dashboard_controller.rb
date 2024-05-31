class Owner::DashboardController < ApplicationController
  before_action :authenticate_admin!
  def index

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
