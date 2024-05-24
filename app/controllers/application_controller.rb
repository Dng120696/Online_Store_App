class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
  end


  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      owner_dashboard_index_path
    elsif resource.is_a?(User)
    customer_client_dashboard_index_path
    end
  end
end
