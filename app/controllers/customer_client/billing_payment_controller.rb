class CustomerClient::BillingPaymentController < ApplicationController
  before_action :authenticate_user!

  def index
    @payment_method = session[:payment_method]
  end

end
