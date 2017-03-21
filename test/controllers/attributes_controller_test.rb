require 'test_helper'

class AttributesControllerTest < ActionDispatch::IntegrationTest
  test "should delete attribute" do
    attribute = create(:attribute)
    project = attribute.parent_resource.project
    resource = attribute.parent_resource
    assert_difference 'Attribute.count', -1 do
      delete project_resource_attribute_path(project, resource, attribute)
    end
    assert_redirected_to project_resource_path(project, resource)
  end
end
