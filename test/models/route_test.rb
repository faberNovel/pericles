require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:route, name: nil).valid?
  end

  test "Two routes within the same resource shouldn't have the same name" do
    route = create(:route)
    assert_not build(:route, name: route.name, resource: route.resource).valid?
  end

  test "shouldn't exist without a http_method" do
    assert_not build(:route, http_method: nil).valid?
  end

  test "shouldn't exist without a url" do
    assert_not build(:route, url: nil).valid?
  end

  test "json_schemas must be a valid JSON text" do
    assert_not build(:route, request_body_schema: "{ invalid }").valid?
  end

  test "json_schemas must conform to the JSON Schema spec" do
    assert_not build(:route, request_body_schema: '{ "type": "invalid" }').valid?
  end

  test "shouldn't exist without a resource" do
    assert_not build(:route, resource: nil).valid?
  end

  test "Two routes within the same resource shouldn't have the same http_method and url" do
    route = create(:route)
    assert_not build(:route, http_method: route.http_method, url: route.url, resource: route.resource).valid?
  end

  test "Route should be valid with all attributes set correctly" do
    assert build(:route, name: "New route", description: "New test route", http_method: :POST, url: "/tests", request_body_schema: "").valid?
  end

  test "routes of project" do
    route = create(:route)
    create(:route, resource: route.resource)
    other_resource = create(:resource)
    other_route = create(:route, resource: other_resource)
    assert_equal Route.of_project(other_resource.project).count, 1, "should have only one route for project"
    assert_equal Route.of_project(other_resource.project).first, other_route, "should be the correct route"
  end
end
