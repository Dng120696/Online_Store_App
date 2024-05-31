# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/pending_user_registration
  def pending_user_registration
    UserMailer.pending_user_registration
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/approved_user_registration
  def approved_user_registration
    UserMailer.approved_user_registration
  end

end
