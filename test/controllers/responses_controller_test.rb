require 'test_helper'

class ResponsesControllerTest < ControllerWithAuthenticationTest
  setup do
    @route = create(:route)
    @route_response = create(:response, route: @route)
    @project = @route.project
  end

  test "should get new" do
    get new_route_response_path(@route)
    assert_response :success
  end

  test "should not get new (not authenticated)" do
    sign_out :user

    get new_route_response_path(@route)
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    get edit_route_response_path(@route, @route_response)
    assert_response :success
  end

  test "should not get edit (not authenticated)" do
    sign_out :user

    get edit_route_response_path(@route, @route_response)
    assert_redirected_to new_user_session_path
  end

  test "should create response" do
    assert_difference('Response.count') do
      post route_responses_path(@route), params: { response: @route_response.attributes }
    end
    assert_redirected_to project_route_path(@project, @route)
  end

  test "should not create response without a status code" do
    @route_response = build(:response, status_code: nil)

    assert_no_difference('Response.count') do
      post route_responses_path(@route), params: { response: @route_response.attributes }
    end
    assert_response :unprocessable_entity
  end

  test "should not create response (not authenticated)" do
    sign_out :user

    assert_no_difference('Response.count') do
      post route_responses_path(@route), params: { response: @route_response.attributes }
    end
    assert_redirected_to new_user_session_path
  end

  test "should update response" do
    assert_not_equal 400, @route_response.status_code

    put route_response_path(@route, @route_response), params: {
      response: { status_code: 400 }
    }
    assert_redirected_to project_route_path(@project, @route)

    assert_equal 400, @route_response.reload.status_code
  end

  test "should not update response if status_code is empty" do
    original_status_code = @route_response.status_code

    put route_response_path(@route, @route_response), params: {
      response: { status_code: "" }
    }
    assert_response :unprocessable_entity
    assert_equal original_status_code, @route_response.reload.status_code
  end

  test "should not update response (not authenticated)" do
    sign_out :user
    original_status_code = @route_response.status_code
    assert_not_equal original_status_code, 400

    put route_response_path(@route, @route_response), params: {
      response: { status_code: 400 }
    }

    assert_redirected_to new_user_session_path
    assert_equal original_status_code, @route_response.reload.status_code
  end

  test "should delete response" do
    assert_difference('Response.count', -1) do
      delete route_response_path(@route, @route_response)
    end
    assert_redirected_to project_route_path(@project, @route)
  end

  test "should not delete response (not authenticated)" do
    sign_out :user

    assert_no_difference('Response.count') do
      delete route_response_path(@route, @route_response)
    end
    assert_redirected_to new_user_session_path
  end

  test 'non member external user should not access project responses' do
    external_user = create(:user, :external)
    sign_in external_user

    get new_route_response_path(@route)
    assert_response :forbidden

    get edit_route_response_path(@route, @route_response)
    assert_response :forbidden

    post route_responses_path(@route), params: { response: @route_response.attributes }
    assert_response :forbidden

    put route_response_path(@route, @route_response), params: {
      response: { status_code: 400 }
    }
    assert_response :forbidden

    delete route_response_path(@route, @route_response)
    assert_response :forbidden
  end

  test 'member external user should access project responses' do
    external_user = create(:user, :external)
    create(:member, project: @project, user: external_user)
    sign_in external_user

    get new_route_response_path(@route)
    assert_response :success

    get edit_route_response_path(@route, @route_response)
    assert_response :success

    post route_responses_path(@route), params: { response: @route_response.attributes }
    assert_redirected_to project_route_path(@project, @route)

    put route_response_path(@route, @route_response), params: {
      response: { status_code: 400 }
    }
    assert_redirected_to project_route_path(@project, @route)

    delete route_response_path(@route, @route_response)
    assert_redirected_to project_route_path(@project, @route)
  end

  test 'non member external user should access public project responses with read-only permission' do
    external_user = create(:user, :external)
    sign_in external_user

    get new_route_response_path(@route)
    assert_response :forbidden

    get edit_route_response_path(@route, @route_response)
    assert_response :forbidden

    post route_responses_path(@route), params: { response: @route_response.attributes }
    assert_response :forbidden

    put route_response_path(@route, @route_response), params: {
      response: { status_code: 400 }
    }
    assert_response :forbidden

    delete route_response_path(@route, @route_response)
    assert_response :forbidden
  end

  test 'unauthenticated user should access public project responses with read-only permission' do
    sign_out :user

    get new_route_response_path(@route)
    assert_redirected_to new_user_session_path

    get edit_route_response_path(@route, @route_response)
    assert_redirected_to new_user_session_path

    post route_responses_path(@route), params: { response: @route_response.attributes }
    assert_redirected_to new_user_session_path

    put route_response_path(@route, @route_response), params: {
      response: { status_code: 400 }
    }
    assert_redirected_to new_user_session_path

    delete route_response_path(@route, @route_response)
    assert_redirected_to new_user_session_path
  end
end
