class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cart, if: :user_signed_in?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname])
  end


  def set_cart
    if user_signed_in?
      @cart = current_user.cart
      @cart_items  = @cart&.cart_items || []
      if @cart
        @cart_items = @cart.cart_items.includes(:product) # Include product to avoid N+1 queries
      else
        @cart_items = []
      end
    end
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Admin)
      owner_dashboard_index_path
    elsif resource.is_a?(User)
    customer_client_dashboard_index_path
    end
  end
end
