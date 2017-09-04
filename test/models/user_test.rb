require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user should have an email" do
    user = build(:user, email: nil)
    assert_not user.valid?
  end
end
