require 'test_helper'

class JsonSchemasControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    project = create(:project)
    get project_json_schemas_path(project)
    assert_response :success
  end

  test "should get new" do
    project = create(:project)
    get new_project_json_schema_path(project)
    assert_response :success
  end

  test "should show json_schema" do
    json_schema = create(:json_schema)
    get project_json_schema_path(json_schema.project, json_schema)
    assert_response :success
  end

  test "should create json_schema" do
    json_schema = build(:json_schema)
    assert_difference('JsonSchema.count') do
      post project_json_schemas_path(json_schema.project), params: { json_schema: json_schema.attributes }
    end
    json_schema = assigns(:json_schema)
    assert_not_nil json_schema, "should create json_schema"
    assert_redirected_to project_json_schema_path(json_schema.project, json_schema)
  end

  test "should not create json_schema without a schema" do
    json_schema = build(:json_schema)
    json_schema.schema = ""
    assert_no_difference('JsonSchema.count') do
      post project_json_schemas_path(json_schema.project), params: { json_schema: json_schema.attributes }
    end
    assert_response :success
  end

  test "should delete json_schema" do
    json_schema = create(:json_schema)
    project = json_schema.project
    assert_difference 'JsonSchema.count', -1 do
      delete project_json_schema_path(project, json_schema)
    end
    assert_redirected_to project_json_schemas_path(project)
  end
end
