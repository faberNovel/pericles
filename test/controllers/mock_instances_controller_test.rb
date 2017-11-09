require 'test_helper'

class MockInstancesControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @resource = create(:resource, project: @project)
    @route = create(:route, resource: @resource, url: "/mock_route")
    @mock_instance = create(:mock_instance, resource: @resource, body: '{}', name: 'old name')
  end

  test "display mock instance creation form" do
    get "/resources/#{@resource.id}/mock_instances/new"
    assert_response :success
  end

  test "mock instance creation" do
    assert_difference 'MockInstance.count' do
      post "/resources/#{@resource.id}/mock_instances", params: { mock_instance: { name: 'nice name', body: '{}'} }
    end
    assert_redirected_to project_resource_path(@project, @resource)
  end

  test "mock instance edition form" do
    get "/mock_instances/#{@mock_instance.id}/edit"
    assert_response :success
  end

  test "mock instance update" do
    patch "/mock_instances/#{@mock_instance.id}", params: { mock_instance: { name: 'nice name', body: '{}'} }
    assert_equal 'nice name', @mock_instance.reload.name
    assert_redirected_to project_resource_path(@project, @resource)
  end

  test "mock instance delete" do
    assert_difference 'MockInstance.count', -1 do
      delete "/mock_instances/#{@mock_instance.id}", params: { mock_instance: { name: 'nice name', body: '{}'} }
    end
    assert_redirected_to project_resource_path(@project, @resource)
  end
end
