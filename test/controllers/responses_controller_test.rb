require 'test_helper'

class ResponsesControllerTest < ControllerWithAuthenticationTest
  test "should get edit" do
    response = create(:response)
    get edit_route_response_path(response.route, response)
    assert_response :success
  end

  test "should not get edit (not authenticated)" do
    sign_out :user
    response = create(:response)
    get edit_route_response_path(response.route, response)
    assert_redirected_to new_user_session_path
  end
end
