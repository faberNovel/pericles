require 'test_helper'

class ResourceInstanceTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:resource_instance, name: nil).valid?
  end

  test "shouldn't exist without a resource" do
    assert_not build(:resource_instance, resource: nil).valid?
  end

  test "have a project" do
    assert build(:resource_instance).project
  end

  test "should be valid in relation to its resource default representation" do
    resource = create(:resource)
    create(:attribute, parent_resource: resource, name: "id", primitive_type: :integer)
    assert build(:resource_instance, body: '{"id": 1}', resource: resource).valid?
  end

  test "should be valid in relation to at least one representation" do
    resource = create(:resource)
    create(:attribute, parent_resource: resource, name: "id", primitive_type: :integer)
    assert_not build(:resource_instance, body: '{}', resource: resource).valid?

    resource.resource_representations << create(:resource_representation)
    assert build(:resource_instance, body: '{}', resource: resource).valid?
  end
end
