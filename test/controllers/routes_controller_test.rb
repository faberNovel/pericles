require 'test_helper'

class RoutesControllerTest < ActionDispatch::IntegrationTest
  test "should show route" do
    route = create(:route, body_schema: "{}")
    get project_resource_route_path(route.resource.project, route.resource, route)
    assert_response :success
  end

  test "should get new" do
    resource = create(:resource)
    get new_project_resource_route_path(resource.project, resource)
    assert_response :success
  end

  test "should get edit" do
    route = create(:route)
    get edit_project_resource_route_path(route.resource.project, route.resource, route)
    assert_response :success
  end

  test "should create route" do
    route = build(:route)
    project = route.resource.project
    resource = route.resource
    assert_difference('Route.count') do
      post project_resource_routes_path(project, resource), params: { route: route.attributes }
    end
    route = assigns(:route)
    assert_not_nil route, "should create route"
    assert_redirected_to project_resource_route_path(project, resource, route)
  end

  test "should not create route without a name" do
    route = build(:route)
    project = route.resource.project
    resource = route.resource
    route.name = ''
    assert_no_difference('Route.count') do
      post project_resource_routes_path(project, resource), params: { route: route.attributes }
    end
    assert_response :unprocessable_entity
  end

  test "should update route" do
    route = create(:route)
    project = route.resource.project
    resource = route.resource
    put project_resource_route_path(project, resource, route), params: { route: { name: 'List users' } }
    assert_redirected_to project_resource_route_path(project, resource, route)
    route.reload
    assert_equal 'List users', route.name
  end

  test "should not update route" do
    route = create(:route)
    project = route.resource.project
    resource = route.resource
    name = route.name
    put project_resource_route_path(project, resource, route), params: { route: { name: '' } }
    assert_response :unprocessable_entity
    route.reload
    assert_equal name, route.name
  end
end