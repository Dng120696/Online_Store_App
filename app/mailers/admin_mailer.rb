class AdminMailer < ApplicationMailer
  def new_user_notification(user, admin)
    @admin = admin
    @user = user
    mail(to: 'stocktrader851@gmail.com', subject: "New User Registration")
  end

  def new_order_notification(admin, order)
    @admin = admin
    @order = order
    mail(to: 'stocktrader851@gmail.com', subject: "New Order Request")
  end

  def cancelled_order_notification(user, admin)
    @admin = admin
    @user = user
    mail(to: 'stocktrader851@gmail.com', subject: "Order Cancellation Request")
  end

  def order_refunded_notification(user, admin)
    @admin = admin
    @user = user
    mail(to: 'stocktrader851@gmail.com', subject: "Refund Request Is Successful")
  end
end
