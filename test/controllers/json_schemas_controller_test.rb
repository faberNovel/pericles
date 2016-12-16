require 'test_helper'

class JsonSchemasControllerTest < ActionDispatch::IntegrationTest

  test "should get new" do
    project = create(:project)
    get new_project_json_schema_path(project)
    assert_response :success
  end

  test "should create json_schema" do
    json_schema = build(:json_schema)
    assert_difference('JsonSchema.count') do
      post project_json_schemas_path(json_schema.project), params: { json_schema: json_schema.attributes }
    end
    assert_not_nil assigns(:json_schema), "should create json_schema"
    #FIX ME when show is done
    #assert_redirected_to json_schema_url(JsonSchema.last)
  end

  test "should not create json_schema without a schema" do
    json_schema = build(:json_schema)
    json_schema.schema = ""
    assert_no_difference('JsonSchema.count') do
      post project_json_schemas_path(json_schema.project), params: { json_schema: json_schema.attributes }
    end
    assert_response :success
  end
end
