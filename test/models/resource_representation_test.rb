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
end
