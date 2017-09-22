require 'test_helper'

class ResponseTest < ActiveSupport::TestCase
  test "shouldn't exist without a status_code" do
    assert_not build(:response, status_code: nil).valid?
  end

  test "body_schema_backup must be a valid JSON text" do
    assert_not build(:response, body_schema_backup: "{ invalid }").valid?
  end

  test "body_schema_backup must conform to the JSON Schema spec" do
    assert_not build(:response, body_schema_backup: '{ "type": "invalid" }').valid?
  end

  test "shouldn't exist without a route" do
    assert_not build(:response, route: nil).valid?
  end

  test "json_schema should be nil if response has no resource_representation" do
    assert_nil build(:response, resource_representation: nil).json_schema
  end

  test "shoud have json_schema if response has resource_representation" do
    assert build(:response, resource_representation: build(:resource_representation)).json_schema
  end
end
