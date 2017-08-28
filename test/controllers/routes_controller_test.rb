require 'test_helper'

class RoutesControllerTest < ActionDispatch::IntegrationTest
  test "should show index" do
    project = create(:project)
    get project_routes_path(project)
    assert_response :success
  end

  test "should show route" do
    route = create(:route, request_body_schema: "{}")
    get resource_route_path(route.resource, route)
    assert_response :success
  end

  test "should get new" do
    resource = create(:resource)
    get new_resource_route_path(resource)
    assert_response :success
  end

  test "should get edit" do
    route = create(:route)
    get edit_resource_route_path(route.resource, route)
    assert_response :success
  end

  test "should create route" do
    route = build(:route)
    resource = route.resource
    assert_difference('Route.count') do
      post resource_routes_path(resource), params: { route: route.attributes }
    end
    route = assigns(:route)
    assert_not_nil route, "should create route"
    assert_redirected_to resource_route_path(resource, route)
  end

  test "should not create route without a name" do
    route = build(:route)
    resource = route.resource
    route.name = ''
    assert_no_difference('Route.count') do
      post resource_routes_path(resource), params: { route: route.attributes }
    end
    assert_response :unprocessable_entity
  end

  test "should update route" do
    route = create(:route)
    resource = route.resource
    put resource_route_path(resource, route), params: { route: { name: 'List users' } }
    assert_redirected_to resource_route_path(resource, route)
    route.reload
    assert_equal 'List users', route.name
  end

  test "should not update route" do
    route = create(:route)
    resource = route.resource
    name = route.name
    put resource_route_path(resource, route), params: { route: { name: '' } }
    assert_response :unprocessable_entity
    route.reload
    assert_equal name, route.name
  end

  test "should delete route" do
    route = create(:route)
    project = route.resource.project
    resource = route.resource
    assert_difference 'Route.count', -1 do
      delete resource_route_path(resource, route)
    end
    assert_redirected_to project_resource_path(project, resource)
  end
end
