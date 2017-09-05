require 'test_helper'

class MocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = create(:project)
    @resource = create(:resource, project: @project)
    @route = create(:route, resource: @resource, url: "/mock_route")
    @main_response = create(:response, route: @route, resource_representation: @resource.resource_representations.first)
    # mocks_controller is not authenticated, but resources_representations_controller is
    @user = create(:user)
    sign_in @user

    get resource_resource_representation_path(@resource, @main_response.resource_representation, format: :json_schema)
    @main_response.update_attribute(:body_schema, @response.body)
    sign_out :user
  end

  test "response of the mocks should match json schema of route" do
    get "/projects/#{@project.id}/mocks/" + @route.url
    assert_response :success
    assert JSON::Validator.validate(@response.body, @main_response.body_schema), "json generated should match json schema"
  end

  test "should have error if route does not exist" do
    assert_raises(ActionController::RoutingError) do
      get "/projects/#{@project.id}/mocks/test"
    end
  end

end
