require 'test_helper'

class RoutesControllerTest < ActionDispatch::IntegrationTest
  test "should show route" do
    route = create(:route, body_schema: "{}")
    get project_resource_route_path(route.resource.project, route.resource, route)
    assert_response :success
  end

  test "should get edit" do
    route = create(:route)
    get edit_project_resource_route_path(route.resource.project, route.resource, route)
    assert_response :success
  end
end