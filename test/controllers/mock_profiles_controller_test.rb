require 'test_helper'

class MockProfilesControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @resource = create(:resource, project: @project)
    @route = create(:route, resource: @resource, url: "/mock_route")
    @mock_instance = create(:mock_instance, resource: @resource, body: '{}', name: 'old name')
    @mock_profile = create(:mock_profile, project: @project)
  end

  test "mock profile edition form" do
    get "/mock_profiles/#{@mock_profile.id}/edit"
    assert_response :success
  end

  test "mock profile update" do
    patch "/mock_profiles/#{@mock_profile.id}", params: { mock_profile: { name: 'nice name', body: '{}'} }
    assert_equal 'nice name', @mock_profile.reload.name
    assert_redirected_to edit_mock_profile_path(@mock_profile)
  end

  test "mock profile create" do
    assert_difference 'MockProfile.count' do
      post "/projects/#{@project.id}/mock_profiles", params: { mock_profile: { name: 'nice name', body: '{}'} }
    end
    assert_redirected_to edit_mock_profile_path(MockProfile.order(:id).last)
  end

  test "mock profile index" do
    get "/projects/#{@project.id}/mock_profiles"
    assert_response :success
  end

  test "mock profile new" do
    get "/projects/#{@project.id}/mock_profiles/new"
    assert_response :success
  end

  test "mock profile mocks" do
    response_ = create(:response, route: @route, resource_representation: create(:resource_representation, resource: @resource))
    mock_picker = create(:mock_picker, response: response_, mock_profile: @mock_profile, response_is_favorite: true)
    mock_picker.mock_instances << @mock_instance
    get "/projects/#{@project.id}/mock_profiles/#{@mock_profile.id}/mocks/#{@route.url}"
    assert_equal response.body, @mock_instance.body
    assert_response :success
  end
end