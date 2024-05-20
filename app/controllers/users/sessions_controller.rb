class Users::SessionsController < Devise::SessionsController
  def create
      if admin_signed_in?
        sign_out(current_admin) # Sign out admin
      end
      super
  end
end
