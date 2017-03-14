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
end