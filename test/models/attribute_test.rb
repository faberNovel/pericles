require 'test_helper'

class AttributeTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:attribute, name: nil).valid?
  end

  test "shouldn't exist without a parent_resource" do
    assert_not build(:attribute, parent_resource: nil).valid?
  end

  test "Two Attributes within the same parent_resource shouldn't have the same name" do
    attribute = create(:attribute)
    assert_not build(:attribute, name: attribute.name, parent_resource: attribute.parent_resource).valid?
    assert_not build(:attribute, name: attribute.name.upcase, parent_resource: attribute.parent_resource).valid?
  end

  test "An attribute's type needs to be defined as a primitive_type or a resource" do
    assert_not build(:attribute, primitive_type: nil, resource: nil).valid?
  end

  test "An attribute's type cannot be defined both as a primitive_type and a resource" do
    assert_not build(:attribute_with_resource, primitive_type: :integer).valid?
  end

  test "An attribute cannot have an enum if it has a resource type" do
    assert_not build(:attribute_with_resource, enum: "not, valid").valid?
  end

  test "Attribute should be valid with all fields set correctly" do
    assert build(:attribute, name: "New Attribute", description: "New test attribute", example: '"Hello"', is_array: true, primitive_type: :string, enum: "valid").valid?
  end
end
