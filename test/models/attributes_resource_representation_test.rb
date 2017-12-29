require 'test_helper'

class AttributesResourceRepresentationTest < ActiveSupport::TestCase
  test "A resource_representation shouldn't be associated with the same attribute twice" do
    resource_representation = create(:resource_representation)
    attribute = create(:attribute, parent_resource: resource_representation.resource)
    create(:attributes_resource_representation, resource_attribute: attribute,
     parent_resource_representation: resource_representation)
    assert_not build(:attributes_resource_representation, resource_attribute: attribute,
     parent_resource_representation: resource_representation).valid?
  end

  test "An attributes_resource_representation with an attribute that has a resource type must have an associated
   resource_representation to represent the resource referenced by the attribute" do
    resource_representation = create(:resource_representation)
    attribute_with_resource = create(:attribute_with_resource, parent_resource: resource_representation.resource)
    assert_not build(:attributes_resource_representation, resource_attribute: attribute_with_resource,
      parent_resource_representation: resource_representation).valid?
  end

  test "An attributes_resource_representation with no key name has attribute default_key_name" do
    attributes_resource_representation = create(:attributes_resource_representation)
    assert_equal attributes_resource_representation.key_name, attributes_resource_representation.resource_attribute.default_key_name
  end

  test "overrided key name is kept if attribute name change" do
    attributes_resource_representation = create(:attributes_resource_representation, custom_key_name: "NiceKeyName")
    assert_equal attributes_resource_representation.key_name, "NiceKeyName"

    attributes_resource_representation.resource_attribute.update(name: 'hi')
    assert_equal attributes_resource_representation.key_name, "NiceKeyName"
  end

  test "default key name is updated if attribute name change" do
    attributes_resource_representation = create(:attributes_resource_representation)
    old_key_name = attributes_resource_representation.key_name

    attributes_resource_representation.resource_attribute.update(name: 'hi')
    assert_not_equal attributes_resource_representation.key_name, old_key_name
  end
end
