require 'test_helper'

class RoutesControllerTest < ControllerWithAuthenticationTest

  test "should show index" do
    project = create(:project)
    get project_routes_path(project)
    assert_response :success
  end

  test "should not show index (not authenticated)" do
    sign_out :user
    project = create(:project)
    get project_routes_path(project)
    assert_redirected_to new_user_session_path
  end

  test "should show route" do
    route = create(:route)
    get resource_route_path(route.resource, route)
    assert_response :success
  end

  test "should not show route (not authenticated)" do
    sign_out :user
    route = create(:route)
    get resource_route_path(route.resource, route)
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    resource = create(:resource)
    get new_resource_route_path(resource)
    assert_response :success
  end

  test "should not get new (not authenticated)" do
    sign_out :user
    resource = create(:resource)
    get new_resource_route_path(resource)
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    route = create(:route)
    get edit_resource_route_path(route.resource, route)
    assert_response :success
  end

  test "should not get edit (not authenticated)" do
    sign_out :user
    route = create(:route)
    get edit_resource_route_path(route.resource, route)
    assert_redirected_to new_user_session_path
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

  test "should not create route (not authenticated)" do
    sign_out :user
    route = build(:route)
    resource = route.resource
    assert_no_difference('Route.count') do
      post resource_routes_path(resource), params: { route: route.attributes }
    end
    assert_redirected_to new_user_session_path
  end

  test "should update route" do
    route = create(:route)
    resource = route.resource
    put resource_route_path(resource, route), params: { route: { url: '/new_url' } }
    assert_redirected_to resource_route_path(resource, route)
    route.reload
    assert_equal '/new_url', route.url
  end

  test "should not update route" do
    route = create(:route)
    resource = route.resource
    url = route.url
    put resource_route_path(resource, route), params: { route: { url: '' } }
    assert_response :unprocessable_entity
    route.reload
    assert_equal url, route.url
  end

  test "should not update route (not authenticated)" do
    sign_out :user
    route = create(:route)
    route_original_url = route.url
    resource = route.resource
    put resource_route_path(resource, route), params: { route: { url: '/new_url' } }
    route.reload
    assert_equal route_original_url, route.url
    assert_redirected_to new_user_session_path
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

  test "should not delete route (not authenticated)" do
    sign_out :user
    route = create(:route)
    resource = route.resource
    assert_no_difference 'Route.count' do
      delete resource_route_path(resource, route)
    end
    assert_redirected_to new_user_session_path
  end
end
