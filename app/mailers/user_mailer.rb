class UserMailer < ApplicationMailer
  default from:'stocktrader851@gmail.com'
  def new_user_registration(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Our Online Store!')
  end

  def notify_order_placed(user)
    @user = user
    mail(to: @user.email, subject: 'Order Being Processed')
  end

end
