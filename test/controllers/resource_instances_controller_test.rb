require 'test_helper'

class ResourceInstancesControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @resource = create(:resource, project: @project)
    @route = create(:route, resource: @resource, url: "/mock_route")
    @resource_instance = create(:resource_instance, resource: @resource, body: '{}', name: 'old name')
  end

  test "display mock instance creation form" do
    get "/resources/#{@resource.id}/resource_instances/new"
    assert_response :success
  end

  test "mock instance creation" do
    assert_difference 'ResourceInstance.count' do
      post "/resources/#{@resource.id}/resource_instances", params: { resource_instance: { name: 'nice name', body: '{}'} }
    end
    assert_redirected_to project_resource_path(@project, @resource)
  end

  test "mock instance edition form" do
    get "/resource_instances/#{@resource_instance.id}/edit"
    assert_response :success
  end

  test "mock instance update" do
    patch "/resource_instances/#{@resource_instance.id}", params: { resource_instance: { name: 'nice name', body: '{}'} }
    assert_equal 'nice name', @resource_instance.reload.name
    assert_redirected_to project_resource_path(@project, @resource)
  end

  test "mock instance delete" do
    assert_difference 'ResourceInstance.count', -1 do
      delete "/resource_instances/#{@resource_instance.id}", params: { resource_instance: { name: 'nice name', body: '{}'} }
    end
    assert_redirected_to project_resource_path(@project, @resource)
  end
end
