require 'test_helper'

class RouteTest < ActiveSupport::TestCase
  test "shouldn't exist without a http_method" do
    assert_not build(:route, http_method: nil).valid?
  end

  test "shouldn't exist without a url" do
    assert_not build(:route, url: nil).valid?
  end

  test "shouldn't exist without a resource" do
    assert_not build(:route, resource: nil).valid?
  end

  test "Two routes within the same resource shouldn't have the same http_method and url" do
    route = create(:route)
    assert_not build(:route, http_method: route.http_method, url: route.url, resource: route.resource).valid?
  end

  test "Route should be valid with all attributes set correctly" do
    assert build(:route, description: "New test route", http_method: :POST, url: "/tests").valid?
  end

  test "routes of project" do
    route = create(:route)
    create(:route, resource: route.resource)
    other_resource = create(:resource)
    other_route = create(:route, resource: other_resource)
    assert_equal other_resource.project.routes.count, 1, "should have only one route for project"
    assert_equal other_resource.project.routes.first, other_route, "should be the correct route"
  end

  test "request_can_have_body" do
    route = create(:route)
    [:POST, :PUT, :PATCH].each do |http_method|
      route.update(http_method: http_method)
      assert route.request_can_have_body
    end

    [:GET, :DELETE].each do |http_method|
      route.update(http_method: http_method)
      assert_not route.request_can_have_body
    end
  end

  test "can_have_query_params" do
    route = create(:route)
    [:POST, :PUT, :PATCH, :DELETE].each do |http_method|
      route.update(http_method: http_method)
      assert_not route.can_have_query_params
    end

    route.update(http_method: :GET)
    assert route.can_have_query_params
  end

  test "have a project" do
    assert build(:route).project
  end
end
