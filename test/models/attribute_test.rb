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
    assert build(:attribute, name: attribute.name.upcase, parent_resource: attribute.parent_resource).valid?
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

  test "An attribute cannot have an enum if it is a boolean" do
    assert_not build(:attribute, primitive_type: :boolean, enum: "not, valid").valid?
  end

  test "An attribute cannot have a scheme if it is not a string" do
    assert_not build(:attribute_with_resource, scheme: create(:scheme)).valid?
    assert_not build(:attribute, primitive_type: :boolean, scheme: create(:scheme)).valid?
  end

  test "A string/integer/number attribute can have a min or max" do
    [:string, :integer, :number].each do |type|
      assert build(:attribute, primitive_type: type, minimum: 3).valid?
      assert build(:attribute, primitive_type: type, maximum: 3).valid?
    end
  end

  test "A resource/boolean/null attribute cannot have a min or max" do
    [:boolean, :null].each do |type|
      assert_not build(:attribute, primitive_type: type, minimum: 3).valid?
      assert_not build(:attribute, primitive_type: type, maximum: 3).valid?
    end

    assert_not build(:attribute_with_resource, maximum: 3).valid?
    assert_not build(:attribute_with_resource, minimum: 3).valid?
  end

  test "Only array attribute can have min_items or max_items" do
    assert build(:attribute, primitive_type: :boolean, is_array: true, min_items: 3).valid?
    assert build(:attribute, primitive_type: :boolean, is_array: true, max_items: 3).valid?

    assert_not build(:attribute, primitive_type: :boolean, is_array: false, max_items: 3).valid?
    assert_not build(:attribute, primitive_type: :boolean, is_array: false, min_items: 3).valid?
  end

  test "An attribute can have a scheme if it is a string" do
    assert build(:attribute, primitive_type: :string, scheme: create(:scheme)).valid?
  end

  test "Attribute should be valid with all fields set correctly" do
    assert build(:attribute,
      name: "New Attribute",
      description: "New test attribute",
      is_array: true,
      primitive_type: :string,
      enum: "valid",
      scheme: create(:scheme)
    ).valid?
  end

  test 'Representation is updated with the attribute' do
    attribute = create(:attribute_with_resource)
    representation = attribute.parent_resource.default_representation
    attributes_resource_representation = representation.attributes_resource_representations.first

    assert attributes_resource_representation.resource_representation_id
    attribute.update(resource_id: nil, primitive_type: :integer)
    assert_not attributes_resource_representation.reload.resource_representation_id
  end
end
