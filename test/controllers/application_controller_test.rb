require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "should redirect to not_found if record does not exist" do
    user = create(:user)
    sign_in user
    get "/projects/0"
    assert_redirected_to "/not_found"
  end
end
