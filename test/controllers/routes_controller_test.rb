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
    get project_route_path(route.project, route)
    assert_response :success
  end

  test "should not show route (not authenticated)" do
    sign_out :user
    route = create(:route)
    get project_route_path(route.project, route)
    assert_redirected_to new_user_session_path
  end

  test 'should get new when project has resource' do
    resource = create(:resource)
    project = resource.project
    get new_project_route_path(project)
    assert_response :success
  end

  test 'should get redirected to resources when project has no resource' do
    project = create(:project)
    get new_project_route_path(project)
    assert_redirected_to project_resources_path(project)
  end

  test "should not get new (not authenticated)" do
    sign_out :user
    get new_project_route_path(create(:project))
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    route = create(:route)
    get edit_project_route_path(route.project, route)
    assert_response :success
  end

  test "should not get edit (not authenticated)" do
    sign_out :user
    route = create(:route)
    get edit_project_route_path(route.project, route)
    assert_redirected_to new_user_session_path
  end

  test "should create route" do
    route = build(:route)
    assert_difference('Route.count') do
      post project_routes_path(route.project), params: { route: route.attributes }
    end
    route = assigns(:route)
    assert_not_nil route, "should create route"
    assert_redirected_to project_route_path(route.project, route)
  end

  test "should not create route (not authenticated)" do
    sign_out :user
    route = build(:route)
    assert_no_difference('Route.count') do
      post project_routes_path(route.project), params: { route: route.attributes }
    end
    assert_redirected_to new_user_session_path
  end

  test "should not create route if resource is not related to project" do
    route = build(:route)
    assert_no_difference('Route.count') do
      post project_routes_path(create(:project)), params: { route: route.attributes }
    end
    assert_response :forbidden
  end

  test "should update route" do
    route = create(:route)
    put project_route_path(route.project, route), params: { route: { url: '/new_url' } }
    assert_redirected_to project_route_path(route.project, route)
    route.reload
    assert_equal '/new_url', route.url
  end

  test "should not update route" do
    route = create(:route)
    url = route.url
    put project_route_path(route.project, route), params: { route: { url: '' } }
    assert_response :unprocessable_entity
    route.reload
    assert_equal url, route.url
  end

  test "should not update route (not authenticated)" do
    sign_out :user
    route = create(:route)
    route_original_url = route.url
    put project_route_path(route.project, route), params: { route: { url: '/new_url' } }
    route.reload
    assert_equal route_original_url, route.url
    assert_redirected_to new_user_session_path
  end

  test "should delete route" do
    route = create(:route)
    assert_difference 'Route.count', -1 do
      delete project_route_path(route.project, route)
    end
    assert_redirected_to project_resource_path(route.project, route.resource)
  end

  test "should not delete route (not authenticated)" do
    sign_out :user
    route = create(:route)
    assert_no_difference 'Route.count' do
      delete project_route_path(route.project, route)
    end
    assert_redirected_to new_user_session_path
  end

  test 'non member external user should not access project routes' do
    external_user = create(:user, :external)
    sign_in external_user

    route = create(:route)
    project = route.project

    get project_routes_path(project)
    assert_response :forbidden

    get new_project_route_path(project)
    assert_response :forbidden

    post project_routes_path(route.project), params: { route: build(:route, resource: route.resource).attributes }
    assert_response :forbidden

    get project_route_path(project, route)
    assert_response :forbidden

    get edit_project_route_path(project, route)
    assert_response :forbidden

    put project_route_path(route.project, route), params: { route: { url: '/new_url' } }
    assert_response :forbidden

    delete project_route_path(project, route)
    assert_response :forbidden
  end

  test 'member external user should access project routes' do
    external_user = create(:user, :external)
    sign_in external_user

    route = create(:route)
    project = route.project
    create(:member, project: project, user: external_user)

    get project_routes_path(project)
    assert_response :success

    get new_project_route_path(project)
    assert_response :success

    post project_routes_path(route.project), params: { route: build(:route, resource: route.resource).attributes }
    created = Route.order(:created_at).last
    assert_redirected_to project_route_path(route.project, created)

    get project_route_path(project, route)
    assert_response :success

    get edit_project_route_path(project, route)
    assert_response :success

    put project_route_path(route.project, route), params: { route: { url: '/new_url' } }
    assert_redirected_to project_route_path(route.project, route)

    delete project_route_path(project, route)
    assert_redirected_to project_resource_path(route.project, route.resource)
  end

  test 'non member external user should access public project routes with read-only permission' do
    external_user = create(:user, :external)
    sign_in external_user

    route = create(:route)
    project = route.project
    project.update(is_public: true)

    get project_routes_path(project)
    assert_response :success

    get new_project_route_path(project)
    assert_response :forbidden

    post project_routes_path(route.project), params: { route: build(:route, resource: route.resource).attributes }
    assert_response :forbidden

    get project_route_path(project, route)
    assert_response :success

    get edit_project_route_path(project, route)
    assert_response :forbidden

    put project_route_path(route.project, route), params: { route: { url: '/new_url' } }
    assert_response :forbidden

    delete project_route_path(project, route)
    assert_response :forbidden
  end

  test 'unauthenticated user should access public project routes with read-only permission' do
    sign_out :user

    route = create(:route)
    project = route.project
    project.update(is_public: true)

    get project_routes_path(project)
    assert_response :success

    get new_project_route_path(project)
    assert_redirected_to new_user_session_path

    post project_routes_path(route.project), params: { route: build(:route, resource: route.resource).attributes }
    assert_redirected_to new_user_session_path

    get project_route_path(project, route)
    assert_response :success

    get edit_project_route_path(project, route)
    assert_redirected_to new_user_session_path

    put project_route_path(route.project, route), params: { route: { url: '/new_url' } }
    assert_redirected_to new_user_session_path

    delete project_route_path(project, route)
    assert_redirected_to new_user_session_path
  end
end
