class UserMailer < ApplicationMailer
  default from:'stocktrader851@gmail.com'
  def pending_user_registration(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Our Online Store!')
  end

  def approved_user_registration(user)
    @user = user
    mail(to: @user.email, subject: "Congratulations, #{@user.firstname} #{@user.lastname}!")
  end
end
