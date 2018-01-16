require 'test_helper'

class ApiErrorInstancesControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @api_error = create(:api_error, project: @project)
    @api_error_instance = create(:api_error_instance, api_error: @api_error)
  end

  test 'should get edit' do
    get edit_api_error_instance_path(@api_error_instance)
    assert_response :success
  end

  test 'should update api_error_instance' do
    assert_not_equal @api_error_instance.name, 'new name'

    patch api_error_instance_path(@api_error_instance), params: {
      api_error_instance: { name: 'new name' }
    }
    assert_redirected_to project_api_error_path(@project, @api_error)
    assert_equal @api_error_instance.reload.name, 'new name'
  end

  test 'should get new' do
    get new_api_error_api_error_instance_path(@api_error)
    assert_response :success
  end

  test 'should create api_error_instance' do
    assert_difference 'ApiErrorInstance.where(api_error: @api_error).count' do
      post api_error_api_error_instances_path(@api_error), params: {
        api_error_instance: @api_error_instance.attributes
      }
    end
    assert_redirected_to project_api_error_path(@project, @api_error)
  end

  test 'should delete api_error_instance' do
    assert_difference('ApiErrorInstance.where(api_error: @api_error).count', -1) do
      delete api_error_instance_path(@api_error_instance)
    end
    assert_redirected_to project_api_error_path(@project, @api_error)
  end

  test 'member external user should access project resource instances' do
    external_user = create(:user, :external)
    sign_in external_user

    create(:member, project: @project, user: external_user)

    get new_api_error_api_error_instance_path(@api_error)
    assert_response :success

    get edit_api_error_instance_path(@api_error_instance)
    assert_response :success

    patch api_error_instance_path(@api_error_instance), params: {
      api_error_instance: { name: 'new name' }
    }
    assert_redirected_to project_api_error_path(@project, @api_error)

    post api_error_api_error_instances_path(@api_error), params: {
      api_error_instance: @api_error_instance.attributes
    }
    assert_redirected_to project_api_error_path(@project, @api_error)

    delete api_error_instance_path(@api_error_instance)
    assert_redirected_to project_api_error_path(@project, @api_error)
  end

  test 'non member external user should not access project api error instances' do
    external_user = create(:user, :external)
    sign_in external_user

    get new_api_error_api_error_instance_path(@api_error)
    assert_response :forbidden

    get edit_api_error_instance_path(@api_error_instance)
    assert_response :forbidden

    patch api_error_instance_path(@api_error_instance), params: {
      api_error_instance: { name: 'new name' }
    }
    assert_response :forbidden

    post api_error_api_error_instances_path(@api_error), params: {
      api_error_instance: @api_error_instance.attributes
    }
    assert_response :forbidden

    delete api_error_instance_path(@api_error_instance)
    assert_response :forbidden
  end

  test 'non member external user should access public project api error instances with read-only permission' do
    external_user = create(:user, :external)
    @project.update(is_public: true)
    sign_in external_user

    get new_api_error_api_error_instance_path(@api_error)
    assert_response :forbidden

    get edit_api_error_instance_path(@api_error_instance)
    assert_response :forbidden

    patch api_error_instance_path(@api_error_instance), params: {
      api_error_instance: { name: 'new name' }
    }
    assert_response :forbidden

    post api_error_api_error_instances_path(@api_error), params: {
      api_error_instance: @api_error_instance.attributes
    }
    assert_response :forbidden

    delete api_error_instance_path(@api_error_instance)
    assert_response :forbidden
  end

  test 'unauthenticated user should access public project api error instances with read-only permission' do
    @project.update(is_public: true)
    sign_out :user

    get new_api_error_api_error_instance_path(@api_error)
    assert_redirected_to new_user_session_path

    get edit_api_error_instance_path(@api_error_instance)
    assert_redirected_to new_user_session_path

    patch api_error_instance_path(@api_error_instance), params: {
      api_error_instance: { name: 'new name' }
    }
    assert_redirected_to new_user_session_path

    post api_error_api_error_instances_path(@api_error), params: {
      api_error_instance: @api_error_instance.attributes
    }
    assert_redirected_to new_user_session_path

    delete api_error_instance_path(@api_error_instance)
    assert_redirected_to new_user_session_path
  end
end
