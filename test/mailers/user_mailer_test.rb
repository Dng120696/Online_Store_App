require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "pending_user_registration" do
    mail = UserMailer.pending_user_registration
    assert_equal "Pending user registration", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "approved_user_registration" do
    mail = UserMailer.approved_user_registration
    assert_equal "Approved user registration", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
