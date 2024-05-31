class Owner::RegistrationsController < ApplicationController
    before_action :authenticate_admin!
  
    def index
      @users = User.where(status: :pending).order(:id)
    end

    def approve
      consumer = User.find(params[:id])
  
      if consumer&.update(status: :approved)
        UserMailer.approved_user_registration(consumer).deliver_later
        redirect_to owner_registrations_path, notice: "Account approved successfully"
      else
        redirect_to owner_registrations_path, alert: "Failed to approve account registration"
      end
  
    end
  end