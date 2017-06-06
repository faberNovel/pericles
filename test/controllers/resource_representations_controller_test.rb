require 'test_helper'

class ResourceRepresentationsControllerTest < ActionDispatch::IntegrationTest
  test "should show resource_representation" do
    representation = create(:resource_representation)
    get resource_representation_path(representation)
    assert_response :success
  end

end
