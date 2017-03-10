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

  test "Resource should be valid with all attributes set correctly" do
    assert build(:resource, name: "New Resource", description: "New test resource").valid?
  end
end
