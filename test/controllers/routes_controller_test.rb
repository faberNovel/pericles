require 'test_helper'

class RoutesControllerTest < ActionDispatch::IntegrationTest
  test "should show route" do
    route = create(:route, request_body_schema: "{}")
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

  test "should delete route" do
    route = create(:route)
    project = route.resource.project
    resource = route.resource
    assert_difference 'Route.count', -1 do
      delete resource_route_path(resource, route)
    end
    assert_redirected_to project_resource_path(project, resource)
  end

  test 'should get json schema associated to resource' do
    resource = create(:resource, name: 'Movie', description: 'A movie')
    create(:attribute, parent_resource: resource, name: 'main_title', description: 'title of the film', primitive_type: :string, enum: "The Godfather, Finding Nemo", pattern: "The Godfather")
    json_schema = {
      type: 'object',
      title: 'Movie',
      description: 'A movie',
      properties: {
        movie: {
          type: 'object',
          properties: {
            main_title: {
              type: 'string',
              description: 'title of the film',
              enum: ["The Godfather", "Finding Nemo"],
              pattern: "The Godfather"
            }
          }
        }
      }
    }
    route = create(:route, resource: resource)
    get project_resource_route_path(route.resource.project, route.resource, route, format: :json_schema)
    assert_equal json_schema.deep_stringify_keys!, JSON.parse(response.body), "json schema is not correct"
  end

  test 'should get json schema associated to resource with reference to other resource' do
    resource = create(:resource, name: 'User', description: 'A user')
    create(:attribute, parent_resource: resource, name: 'name', description: 'name of the user', primitive_type: :string)
    create(:attribute, parent_resource: resource, name: 'manager', description: 'manager of the user', resource: resource, primitive_type: nil)
    json_schema = {
      type: 'object',
      title: 'User',
      description: 'A user',
      properties: {
        user: {
          type: 'object',
          properties: {
            name: { type: 'string', description: 'name of the user'},
            manager: {
              type: 'object',
              description: 'manager of the user',
              title: 'User'
            }
          }
        }
      }
    }
    route = create(:route, resource: resource)
    get project_resource_route_path(route.resource.project, route.resource, route, format: :json_schema)
    assert_equal json_schema.deep_stringify_keys!, JSON.parse(response.body), "json schema is not correct"
  end

  test 'should get json schema associated to resource on collection route' do
    resource = create(:resource, name: 'Movie', description: 'A movie')
    create(:attribute, parent_resource: resource, name: 'main_title', description: 'title of the film', primitive_type: :string)
    json_schema = {
      type: 'object',
      title: 'Movie',
      description: 'A movie',
      properties: {
        movies: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              main_title: {
                type: 'string',
                description: 'title of the film'
              }
            }
          }
        }
      }
    }
    route = create(:route, resource: resource, url: '/movies', http_method: :GET)
    get project_resource_route_path(route.resource.project, route.resource, route, format: :json_schema)
    assert_equal json_schema.deep_stringify_keys!, JSON.parse(response.body), "json schema is not correct"
  end

end
