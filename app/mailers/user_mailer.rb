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

  def notify_order_cancelled(user, order)
    @order = order
    @user = user
    mail(to: @user.email, subject: 'Your Order Was Cancelled')
  end

  def notify_order_refunded(user, order)
    @user = user
    @order = order
    mail(to: @user.email, subject: 'Your Order Was Refunded')
  end
end
