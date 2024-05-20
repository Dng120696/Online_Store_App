class HomeController < ApplicationController
  def home
    if user_signed_in?
      flash[:alert] = "You are already signed in."
      redirect_to home_path
    elsif admin_signed_in?
      flash[:alert] = "You are already signed in."
      redirect_to admin_dashboard_index_path
    end
  end


end
