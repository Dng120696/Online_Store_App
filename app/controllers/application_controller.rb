class ApplicationController < ActionController::Base
  helper_method :user_signed_in?
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
  end


  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      owner_dashboard_index_path
    else
      root_path
    end
  end
end
