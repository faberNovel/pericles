require 'test_helper'

class MockInstancesControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @resource = create(:resource, project: @project)
    @route = create(:route, resource: @resource, url: "/mock_route")
    @response = create(:response, route: @route, resource_representation: @resource.resource_representations.first)
  end

  test "display mock instance form" do
    get "/responses/#{@response.id}/mock_instances/new"
    assert_response :success
  end

  test "mock instance creation" do
    assert_difference 'MockInstance.count' do
      post "/responses/#{@response.id}/mock_instances", params: { mock_instance: { name: 'nice name', body: '{}'} }
    end
    assert_redirected_to resource_route_path(@resource, @route)
  end
end
