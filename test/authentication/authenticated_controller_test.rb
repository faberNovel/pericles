require 'test_helper'

class AuthenticatedControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to sign_in view when not authenticated" do
    get root_path
    assert_redirected_to new_user_session_path
  end
end
