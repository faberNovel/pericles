require 'test_helper'

class MockProfilesControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @resource = create(:resource, project: @project)
    @resource.resource_attributes.create(primitive_type: :integer, name: 'id')
    @route = create(:route, resource: @resource, url: "/mock_route")
    @resource_instance = create(:resource_instance, resource: @resource, body: {id: 1}.to_json)
    @mock_profile = create(:mock_profile, project: @project)
  end

  test "mock profile edition form" do
    get "/mock_profiles/#{@mock_profile.id}/edit"
    assert_response :success
  end

  test "mock profile update" do
    patch "/mock_profiles/#{@mock_profile.id}", params: { mock_profile: { name: 'nice name' } }
    assert_equal 'nice name', @mock_profile.reload.name
    assert_redirected_to edit_mock_profile_path(@mock_profile)
  end

  test "mock profile add parent" do
    parent = create(:mock_profile)
    patch "/mock_profiles/#{@mock_profile.id}", params: { mock_profile: { name: 'nice name', parent_id: parent.id} }
    assert_equal @mock_profile.reload.parent, parent
    assert_redirected_to edit_mock_profile_path(@mock_profile)
  end

  test "mock profile cannot add cyclic dependency" do
    patch "/mock_profiles/#{@mock_profile.id}", params: { mock_profile: { name: 'nice name', parent_id: @mock_profile.id} }
    assert_response 422
  end

  test "mock profile create" do
    assert_difference 'MockProfile.count' do
      post "/projects/#{@project.id}/mock_profiles", params: { mock_profile: { name: 'nice name' } }
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
    r = create(:response, route: @route, resource_representation: @resource.default_representation)
    mock_picker = create(:mock_picker, response: r)
    @mock_profile.mock_pickers << mock_picker
    mock_picker.resource_instances << @resource_instance
    get "/projects/#{@project.id}/mock_profiles/#{@mock_profile.id}/mocks#{@route.url}"
    assert_equal response.body, @resource_instance.body
    assert_response :success
  end

  test "mock profile mocks using parent" do
    r = create(:response, route: @route, resource_representation: @resource.default_representation)
    mock_profile_child = create(:mock_profile)
    mock_profile_child.parent = @mock_profile
    mock_profile_child.save
    parent_mock_picker = create(:mock_picker, response: r)
    @mock_profile.mock_pickers << parent_mock_picker
    parent_mock_picker.resource_instances << @resource_instance

    get "/projects/#{@project.id}/mock_profiles/#{mock_profile_child.id}/mocks#{@route.url}"

    assert_equal response.body, @resource_instance.body
    assert_response :success
  end

  test "mock profile mocks using overrided picker first" do
    r = create(:response, route: @route, resource_representation: @resource.default_representation)
    mock_profile_child = create(:mock_profile)
    mock_profile_child.parent = @mock_profile
    mock_profile_child.save
    parent_mock_picker = create(:mock_picker, response: r)
    @mock_profile.mock_pickers << parent_mock_picker
    parent_mock_picker.resource_instances << @resource_instance

    mock_picker_child = create(:mock_picker, response: r)
    mock_profile_child.mock_pickers << mock_picker_child
    resource_instance = create(:resource_instance, resource: @resource, body: {id: 2}.to_json)
    mock_picker_child.resource_instances << resource_instance

    get "/projects/#{@project.id}/mock_profiles/#{mock_profile_child.id}/mocks#{@route.url}"

    assert_not_equal response.body, @resource_instance.body
    assert_equal response.body, resource_instance.body
    assert_response :success
  end
end