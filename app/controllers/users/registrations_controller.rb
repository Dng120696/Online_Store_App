# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def new
    build_resource({})
    resource.build_address
    respond_with self.resource
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname,:lastname,address_attributes: [:id, :street, :city, :country, :zip_code,:state_or_province, :_destroy]])
    devise_parameter_sanitizer.permit(:account_update, keys: [:firstname,:lastname,address_attributes: [:id, :street, :city, :country, :zip_code,:state_or_province,  :_destroy]])
  end

end
