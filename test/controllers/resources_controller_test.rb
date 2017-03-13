require 'test_helper'

class ResourcesControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    project = create(:project)
    get project_resources_path(project)
    assert_response :success
  end
end