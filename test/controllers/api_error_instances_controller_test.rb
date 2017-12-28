require 'test_helper'

class ApiErrorInstancesControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @api_error = create(:api_error, project: @project)
    @api_error_instance = create(:api_error_instance, api_error: @api_error)
  end

  test 'member external user should access project resource instances' do
    external_user = create(:user, email: 'michel@external.com')
    sign_in external_user

    create(:member, project: @project, user: external_user)

    get new_api_error_api_error_instance_path(@api_error)
    assert_response :success

    get edit_api_error_instance_path(@api_error_instance)
    assert_response :success
  end

  test 'non member external user should not access project api error instances' do
    external_user = create(:user, email: 'michel@external.com')
    sign_in external_user

    get new_api_error_api_error_instance_path(@api_error)
    assert_response :forbidden

    get edit_api_error_instance_path(@api_error_instance)
    assert_response :forbidden
  end
end
