require 'test_helper'

class ResourceInstancesControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @resource = create(:resource, project: @project)
    @route = create(:route, resource: @resource, url: '/mock_route')
    @resource_instance = create(:resource_instance, resource: @resource, body: '{}', name: 'old name')
  end

  test 'display mock instance creation form' do
    get "/resources/#{@resource.id}/resource_instances/new"
    assert_response :success
  end

  test 'mock instance creation' do
    assert_difference 'ResourceInstance.count' do
      post "/resources/#{@resource.id}/resource_instances", params: { resource_instance: { name: 'nice name', body: '{}' } }
    end
    assert_redirected_to project_resource_path(@project, @resource, anchor: 'pills-resource-instances')
  end

  test 'mock instance edition form' do
    get "/resource_instances/#{@resource_instance.id}/edit"
    assert_response :success
  end

  test 'mock instance update' do
    patch "/resource_instances/#{@resource_instance.id}", params: { resource_instance: { name: 'nice name', body: '{}' } }
    assert_equal 'nice name', @resource_instance.reload.name
    assert_redirected_to project_resource_path(@project, @resource, :anchor => 'pills-resource-instances')
  end

  test 'mock instance delete' do
    assert_difference 'ResourceInstance.count', -1 do
      delete "/resource_instances/#{@resource_instance.id}", params: { resource_instance: { name: 'nice name', body: '{}' } }
    end
    assert_redirected_to project_resource_path(@project, @resource, :anchor => 'pills-resource-instances')
  end

  test 'member external user should access project resource instances' do
    external_user = create(:user, :external)
    sign_in external_user

    create(:member, project: @project, user: external_user)

    get new_resource_resource_instance_path(@resource)
    assert_response :success

    get edit_resource_instance_path(@resource_instance)
    assert_response :success

    patch resource_instance_path(@resource_instance), params: {
      resource_instance: { name: 'new name' }
    }
    assert_redirected_to project_resource_path(@project, @resource, :anchor => 'pills-resource-instances')

    post resource_resource_instances_path(@resource), params: {
      resource_instance: @resource_instance.attributes
    }
    assert_redirected_to project_resource_path(@project, @resource, :anchor => 'pills-resource-instances')

    delete resource_instance_path(@resource_instance)
    assert_redirected_to project_resource_path(@project, @resource, :anchor => 'pills-resource-instances')
  end

  test 'non member external user should not access project resource instances' do
    external_user = create(:user, :external)
    sign_in external_user

    get new_resource_resource_instance_path(@resource)
    assert_response :forbidden

    get edit_resource_instance_path(@resource_instance)
    assert_response :forbidden

    patch resource_instance_path(@resource_instance), params: {
      resource_instance: { name: 'new name' }
    }
    assert_response :forbidden

    post resource_resource_instances_path(@resource), params: {
      resource_instance: @resource_instance.attributes
    }
    assert_response :forbidden

    delete resource_instance_path(@resource_instance)
    assert_response :forbidden
  end

  test 'non member external user should access public project resource instances with read-only permission' do
    external_user = create(:user, :external)
    @project.update(is_public: true)
    sign_in external_user

    get new_resource_resource_instance_path(@resource)
    assert_response :forbidden

    get edit_resource_instance_path(@resource_instance)
    assert_response :forbidden

    patch resource_instance_path(@resource_instance), params: {
      resource_instance: { name: 'new name' }
    }
    assert_response :forbidden

    post resource_resource_instances_path(@resource), params: {
      resource_instance: @resource_instance.attributes
    }
    assert_response :forbidden

    delete resource_instance_path(@resource_instance)
    assert_response :forbidden
  end

  test 'unauthenticated user should access public project resource instances with read-only permission' do
    @project.update(is_public: true)
    sign_out :user

    get new_resource_resource_instance_path(@resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get edit_resource_instance_path(@resource_instance)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    patch resource_instance_path(@resource_instance), params: {
      resource_instance: { name: 'new name' }
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    post resource_resource_instances_path(@resource), params: {
      resource_instance: @resource_instance.attributes
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    delete resource_instance_path(@resource_instance)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end
end
