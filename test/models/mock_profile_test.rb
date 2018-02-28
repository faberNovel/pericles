require 'test_helper'

class MockProfileTest < ActiveSupport::TestCase
  setup do
    @project = create(:project)
    @resource = create(:resource, project: @project)
    a = @resource.resource_attributes.create(primitive_type: :integer, name: 'id')
    create(:attributes_resource_representation,
      resource_attribute: a,
      parent_resource_representation: @resource.default_representation,
      resource_representation: a.resource&.default_representation,
      is_required: true
    )
    @route = create(:route, resource: @resource, url: "/mock_route")
    @response = create(:response, route: @route, resource_representation: @resource.default_representation)
    @resource_instance = create(:resource_instance, resource: @resource, body: {id: 1}.to_json)
    @mock_profile = create(:mock_profile, project: @project)
  end

  test "inherited_and_self_mock_pickers_of" do
    assert_empty @mock_profile.inherited_and_self_mock_pickers_of(@route)

    mock_picker = create(:mock_picker, response: @response)
    @mock_profile.mock_pickers << mock_picker

    assert_equal [mock_picker], @mock_profile.inherited_and_self_mock_pickers_of(@route)
    assert_empty @mock_profile.inherited_and_self_mock_pickers_of(create(:route, resource: @resource, url: "/other"))

    child_mock_profile = create(:mock_profile, project: @project)
    child_mock_profile.parent = @mock_profile
    child_mock_profile.save
    child_mock_picker = create(:mock_picker, response: @response)
    child_mock_profile.mock_pickers << child_mock_picker

    assert_equal [child_mock_picker, mock_picker], child_mock_profile.inherited_and_self_mock_pickers_of(@route)
    assert_equal [mock_picker], @mock_profile.inherited_and_self_mock_pickers_of(@route)
  end
end
