require 'test_helper'

class ResourcesControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    project = create(:project)
    get project_resources_path(project)
    assert_response :success
  end

  test "should get new" do
    project = create(:project)
    get new_project_resource_path(project)
    assert_response :success
    assert_not assigns[:selectable_resources].include?(assigns[:resource])
  end

  test "should create resource" do
    resource = build(:resource)
    assert_difference('Resource.count') do
      post project_resources_path(resource.project), params: { resource: resource.attributes }
    end
    resource = assigns[:resource]
    assert_not_nil resource, "should create resource"
    #FIXME
    #assert_redirected_to project_resource_path(resource.project, resource)
  end

  test "should not create resource without a name" do
    resource = build(:resource)
    resource.name = ""
    assert_no_difference('Resource.count') do
      post project_resources_path(resource.project), params: { resource: resource.attributes }
    end
    assert_response :success
  end
end