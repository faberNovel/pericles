require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "should rescue ActiveRecord::RecordNotFound exceptions" do
    get "/projects/:id"
    assert_redirected_to "/not_found"
  end
end
