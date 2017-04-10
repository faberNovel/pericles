require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  test "shouldn't exist without a status_code" do
    assert_not build(:response, status_code: nil).valid?
  end

  test "body_schema must be a valid JSON text" do
    assert_not build(:response, body_schema: "{ invalid }").valid?
  end

  test "body_schema must conform to the JSON Schema spec" do
    assert_not build(:response, body_schema: '{ "type": "invalid" }').valid?
  end

  test "shouldn't exist without a route" do
    assert_not build(:response, route: nil).valid?
  end
end
