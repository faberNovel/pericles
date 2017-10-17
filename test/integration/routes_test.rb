require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  test "Undefined routes should map to the not_found action of the errors controller" do
    assert_recognizes({controller: 'errors', action: 'not_found', path: 'abcdefg'}, 'abcdefg')
  end
end