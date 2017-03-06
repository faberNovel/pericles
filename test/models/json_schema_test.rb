require 'test_helper'

class JsonSchemaTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:json_schema, name: nil).valid?
  end

  test "shouldn't exist without a schema" do
    assert_not build(:json_schema, schema: nil).valid?
    assert_not build(:json_schema, schema: "").valid?
  end

  test "schema must be a valid JSON text" do
    assert_not build(:json_schema, schema: "{ invalid }").valid?
  end

  test "schema must conform to the JSON Schema spec" do
    assert_not build(:json_schema, schema: '{ "type": "invalid" }').valid?
  end

  test "shouldn't exist without a project" do
    assert_not build(:json_schema, project: nil).valid?
  end

  test "Two Json_schemas should not have the same name and project" do
    first_json_schema = create(:json_schema)
    assert_not build(:json_schema, name: first_json_schema.name, project: first_json_schema.project).valid?
  end

  test "Json_schema should be valid with all attributes set correctly" do
    assert build(:json_schema, name: "JSON Schema", schema: '{ "type": "string" }').valid?
  end
end
