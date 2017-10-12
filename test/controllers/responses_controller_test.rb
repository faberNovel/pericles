require 'test_helper'

class ResponsesControllerTest < ControllerWithAuthenticationTest
  test "should get new" do
    route = create(:route)
    get new_route_response_path(route)
    assert_response :success
  end

  test "should not get new (not authenticated)" do
    sign_out :user
    route = create(:route)
    get new_route_response_path(route)
    assert_redirected_to new_user_session_path
  end

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

  test "should update response" do
    response = create(:response)
    route = response.route
    resource = route.resource
    put route_response_path(route, response), params: { response: { status_code: 400 } }
    assert_redirected_to resource_route_path(resource, route)
    response.reload
    assert_equal 400, response.status_code
  end

  test "should not update response" do
    response = create(:response)
    route = response.route
    original_status_code = response.status_code
    put route_response_path(route, response), params: { response: { status_code: "" } }
    assert_response :unprocessable_entity
    response.reload
    assert_equal original_status_code, response.status_code
  end

  test "should not update response (not authenticated)" do
    sign_out :user
    response = create(:response)
    route = response.route
    original_status_code = response.status_code
    put route_response_path(route, response), params: { response: { status_code: 400 } }
    assert_redirected_to new_user_session_path
    response.reload
    assert_equal original_status_code, response.status_code
  end
end
