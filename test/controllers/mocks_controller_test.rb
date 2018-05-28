require 'test_helper'

class MocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = create(:project)
    @resource = create(:resource, project: @project)
    @route = create(:route, resource: @resource, url: '/mock_route')
    @main_response = create(:response, route: @route, resource_representation: @resource.resource_representations.first)
  end

  test 'response of the mocks should match json schema of route' do
    get "/projects/#{@project.id}/mocks/" + @route.url
    assert_response :success
    assert JSON::Validator.validate(@response.body, @main_response.json_schema), 'json generated should match json schema'
  end

  test 'should have error if route does not exist' do
    assert_raises(ActionController::RoutingError) do
      get "/projects/#{@project.id}/mocks/test"
    end
  end

  test 'should have error if response does not exist' do
    @route.responses.delete_all
    get "/projects/#{@project.id}/mocks/" + @route.url
    assert_response :not_found
  end
end
