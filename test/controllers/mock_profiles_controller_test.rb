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
end