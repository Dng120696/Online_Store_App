class AdminMailer < ApplicationMailer
  def new_user_approval(user, admin)
    @admin = admin
    @user = user
    mail(to: 'stocktrader851@gmail.com', subject: "New User Registration")
  end
end
