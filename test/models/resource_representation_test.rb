require 'test_helper'

class ResourceRepresentationTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:resource_representation, name: nil).valid?
  end

  test "shouldn't exist without a resource" do
    assert_not build(:resource_representation, resource: nil).valid?
  end

  test "Two ResourceRepresentations within a resource shouldn't have the same name" do
    resource_rep = create(:resource_representation)
    assert_not build(:resource_representation, name: resource_rep.name, resource: resource_rep.resource).valid?
    assert_not build(:resource_representation, name: resource_rep.name.upcase, resource: resource_rep.resource).valid?
  end

  test "ResourceRepresentation should be valid with all attributes set correctly" do
    assert build(:resource_representation, name: "Representation", description: "New test ResourceRepresentation").valid?
  end

  test "find_parent_resource_representations should return all parent resource_representations
   for a given resource representation" do
    project = create(:project)
    resource = create(:resource, project: project)
    resource_representation = create(:resource_representation, resource: resource)

    expected_result = []
    assert_equal expected_result, resource_representation.find_parent_resource_representations

    parent_resource = create(:resource, project: project)
    resource_attribute = create(:attribute_with_resource, parent_resource: parent_resource, resource: resource)
    parent_resource_representation = create(:resource_representation, resource: parent_resource)
    create(:attributes_resource_representation, parent_resource_representation: parent_resource_representation,
     resource_attribute: resource_attribute, resource_representation: resource_representation)

    grand_parent_resource = create(:resource, project: project)
    parent_resource_attribute = create(:attribute_with_resource, parent_resource: grand_parent_resource,
     resource: parent_resource)
    grand_parent_resource_representation = create(:resource_representation, resource: grand_parent_resource)
    create(:attributes_resource_representation, parent_resource_representation: grand_parent_resource_representation,
     resource_attribute: parent_resource_attribute, resource_representation: parent_resource_representation)

    expected_result = [parent_resource_representation, grand_parent_resource_representation]
    assert_equal expected_result, resource_representation.find_parent_resource_representations
   end

  test "resource_representation_with_attributes_resource_reps has attributes_resource_representations" do
    assert_operator build(:resource_representation_with_attributes_resource_reps).attributes_resource_representations.length, :>, 0
  end

  test "have a project" do
    assert build(:resource_representation).project
  end
end
