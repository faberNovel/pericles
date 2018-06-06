require 'test_helper'

class ValidationTest < ActiveSupport::TestCase
  test 'Validation should be valid with all attributes set correctly' do
    assert build(:validation, json_schema: '{"type": "string"}', json_instance: '"hello"').valid?
  end

  test 'status should be success when validation has no json_errors' do
    validation = create(:validation)
    assert_equal :success, validation.status
  end

  test "status should be schema_parse_error when validation has only one json_schema_error
   with parse_error as description" do
    validation = create(:validation, json_schema: 'abcdefg')
    assert_equal :schema_parse_error, validation.status
  end

  test "status should be schema_validation_error when validation has a json_schema_error
   without parse_error as description" do
    validation = create(:validation, json_schema: '{ "type" : "hello" }')
    assert_equal :schema_validation_error, validation.status
  end

  test "status should be instance_parse_error when validation has only one json_instance_error
   with parse_error as description" do
    validation = create(:validation, json_instance: 'abcdefg')
    assert_equal :instance_parse_error, validation.status
  end

  test "status should be instance_validation_error when validation has a json_instance_error
   without parse_error as description" do
    validation = create(:validation, json_schema: '{ "type" : "string" }', json_instance: '3')
    assert_equal :instance_validation_error, validation.status
  end
end
