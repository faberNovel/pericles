require 'test_helper'

class ValidationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_validation_path
    assert_response :success
  end

  test "should return bad_request status code if validation key is missing" do
    assert_no_difference('Validation.count') do
      post validations_path, params: {}
    end
    assert_response :bad_request
  end

  test "should return created status code if json_schema or json_instance is not a string" do
    assert_difference('Validation.count') do
      post validations_path, params: { validation: { json_schema: "{}" } }
    end
    response = JSON.parse(@response.body)
    assert_not_nil response["validation"]
    validation = response["validation"]
    assert_equal "instance_parse_error", validation["status"]
    assert_equal "parse_error", validation["json_errors"][0]["description"]
    assert_response :created

    assert_difference('Validation.count') do
      post validations_path, params: { validation: { json_instance: "{}" } }
    end
    response = JSON.parse(@response.body)
    assert_not_nil response["validation"]
    validation = response["validation"]
    assert_equal "schema_parse_error", validation["status"]
    assert_equal "parse_error", validation["json_errors"][0]["description"]
    assert_response :created

    assert_difference('Validation.count') do
      post validations_path, params: { validation: { test: "hello" } }
    end
    response = JSON.parse(@response.body)
    assert_not_nil response["validation"]
    validation = response["validation"]
    assert_equal "schema_parse_error", validation["status"]
    assert_equal "parse_error", validation["json_errors"][0]["description"]
    assert_response :created
  end

  test "should return created status_code if json_schema is invalid" do
    #parse_error
    assert_difference('Validation.count') do
      post validations_path, params: { validation: { json_schema: "abcdefg", json_instance: "{}" } }
    end
    response = JSON.parse(@response.body)
    assert_not_nil response["validation"]
    validation = response["validation"]
    assert_equal "schema_parse_error", validation["status"]
    assert_equal "parse_error", validation["json_errors"][0]["description"]
    assert_response :created

    #validation_error
    assert_difference('Validation.count') do
      post validations_path, params: { validation: { json_schema: '{ "type" : "hello" }', json_instance: "{}" } }
    end
    response = JSON.parse(@response.body)
    assert_not_nil response["validation"]
    validation = response["validation"]
    assert_equal "schema_validation_error", validation["status"]
    assert validation["json_errors"].length > 0
    assert_response :created
  end

  test "should return created status_code if json_instance is invalid" do
    #parse_error
    assert_difference('Validation.count') do
      post validations_path, params: { validation: { json_schema: "{}", json_instance: "abcdefg" } }
    end
    response = JSON.parse(@response.body)
    assert_not_nil response["validation"]
    validation = response["validation"]
    assert_equal "instance_parse_error", validation["status"]
    assert_equal "parse_error", validation["json_errors"][0]["description"]
    assert_response :created
  end

  test "should return created status_code if json_instance is valid" do
    #validation_error
    assert_difference('Validation.count') do
      post validations_path, params: { validation: { json_schema: '{ "type" : "string" }', json_instance: "3" } }
    end
    response = JSON.parse(@response.body)
    assert_not_nil response["validation"]
    validation = response["validation"]
    assert_equal "instance_validation_error", validation["status"]
    assert validation["json_errors"].length > 0
    assert_response :created

    #success
    assert_difference('Validation.count') do
      post validations_path, params: { validation: { json_schema: '{ "type" : "string" }', json_instance: '"hello"' } }
    end
    response = JSON.parse(@response.body)
    assert_not_nil response["validation"]
    validation = response["validation"]
    assert_equal "success", validation["status"]
    assert_equal [], validation["json_errors"]
    assert_response :created
  end
end
