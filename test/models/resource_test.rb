require 'test_helper'

class ResourceTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:resource, name: nil).valid?
  end

  test "shouldn't exist without a project" do
    assert_not build(:resource, project: nil).valid?
  end

  test "Two resources within a project shouldn't have the same name" do
    resource = create(:resource)
    assert_not build(:resource, name: resource.name, project: resource.project).valid?
    assert_not build(:resource, name: resource.name.upcase, project: resource.project).valid?
  end

  test 'Resource should be valid with all attributes set correctly' do
    assert build(:resource, name: 'New Resource', description: 'New test resource').valid?
  end

  test 'After a resource is created, it should have an associated default resource representation' do
    resource = create(:resource)
    assert resource.resource_representations.any?
  end

  test 'Can create attributes from json' do
    resource = create(:resource)
    assert_difference 'Attribute.count', 6 do
      resource.try_create_attributes_from_json(
        '
        {
          "id": 1,
          "number": 2,
          "float": 2.1,
          "boolean": true,
          "string": "cool",
          "null": null
        }
        '
      )
    end

    assert_equal resource.resource_attributes.where(primitive_type: :integer, is_array: false).count, 2
    assert_equal resource.resource_attributes.where(primitive_type: :number, is_array: false).count, 1
    assert_equal resource.resource_attributes.where(primitive_type: :boolean, is_array: false).count, 1
    assert_equal resource.resource_attributes.where(primitive_type: :string, is_array: false).count, 1
    assert_equal resource.resource_attributes.where(primitive_type: :null, is_array: false).count, 1
  end

  test 'Can create attributes from json array' do
    resource = create(:resource)
    assert_difference 'Attribute.where(is_array: true).count', 5 do
      resource.try_create_attributes_from_json(
        '
        {
          "id": [1],
          "number": [2],
          "float": [2.1],
          "boolean": [true],
          "string": ["cool"],
          "empty": [],
          "multiple": ["string", 1, 1.2]
        }
        '
      )
    end

    assert_equal resource.resource_attributes.where(primitive_type: :integer, is_array: true).count, 2
    assert_equal resource.resource_attributes.where(primitive_type: :number, is_array: true).count, 1
    assert_equal resource.resource_attributes.where(primitive_type: :boolean, is_array: true).count, 1
    assert_equal resource.resource_attributes.where(primitive_type: :string, is_array: true).count, 1
  end

  test 'Can create attributes from nested json if key match existing resource name' do
    project = create(:project)
    resource = create(:resource, project: project)
    resource_object = create(:resource, project: project, name: 'Object')
    resource_nice_object = create(:resource, project: project, name: 'NiceObjects')
    gym = create(:resource, project: project, name: 'Gym')
    assert_difference 'Attribute.where.not(resource: nil).count', 4 do
      resource.try_create_attributes_from_json(
        '
        {
          "object": {"id": 1},
          "very_nice_object": {"id": 1},
          "nice_objects": [{"id": 1}],
          "subscription_gym": {"id": 1}
        }
        '
      )
    end
    assert_equal resource.resource_attributes.where(resource: resource_object, is_array: false).count, 1
    assert_equal resource.resource_attributes.where(resource: resource_nice_object, is_array: false).count, 1
    assert_equal resource.resource_attributes.where(resource: resource_nice_object, is_array: true).count, 1
    assert_equal resource.resource_attributes.where(resource: gym, is_array: false).count, 1
  end

  test 'not used in other resources scopes unused resource' do
    unused_resource = create(:resource)
    assert_equal [unused_resource], Resource.not_used_in_other_resources
  end

  test 'not used in other resources does not scope used resource' do
    used_resource = create(:resource)
    using_resource = create(:resource)
    create(:attribute_with_resource, parent_resource: using_resource, resource: used_resource)
    assert_equal [using_resource], Resource.not_used_in_other_resources
  end

  test 'not used in other resources scopes resource using itself' do
    using_itself_resource = create(:resource)
    create(:attribute_with_resource, parent_resource: using_itself_resource, resource: using_itself_resource)
    assert_equal [using_itself_resource], Resource.not_used_in_other_resources
  end
end
