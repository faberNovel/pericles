require 'test_helper'

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "should handle redirection to /not_found by returning not_found status code" do
    get "/not_found"
    assert_response :not_found
  end
end
