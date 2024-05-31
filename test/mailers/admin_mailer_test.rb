require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test "new_user_approval" do
    mail = AdminMailer.new_user_approval
    assert_equal "New user approval", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
