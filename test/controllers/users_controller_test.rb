require 'test_helper'

class UsersControllerTest < ControllerWithAuthenticationTest
  test "should show user" do
    get user_path(@user)
    assert_response :success
  end

  test "shouldn't show user (not authenticated)" do
    sign_out :user
    get user_path(@user)
    assert_redirected_to new_user_session_path
  end
end