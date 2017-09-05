require 'test_helper'

class InstancesControllerTest < ControllerWithAuthenticationTest

  test "should create instance" do
    json_schema = {
      type: 'object',
      title: "Movie",
      description: 'A movie',
      properties: {
        movie: {
          type: 'object',
          properties: {
            main_title: {
              type: 'string',
              description: 'title of the film',
              enum: ["The Godfather", "Finding Nemo"]
            }
          },
          required: ["main_title"]
        }
      },
      required: ['movie']
    }
    post instances_path, headers: { 'Accept' => 'application/json' }, params: {schema: json_schema}
    assert_response :success
    assert JSON::Validator.validate(response.body, json_schema), "json generated should match json schema"
  end

  test "should not create instance (not authenticated)" do
    sign_out :user
    json_schema = {
      type: 'object',
      title: "Movie",
      description: 'A movie',
      properties: {
        movie: {
          type: 'object',
          properties: {
            main_title: {
              type: 'string',
              description: 'title of the film',
              enum: ["The Godfather", "Finding Nemo"],
              pattern: "The Godfather II"
            }
          },
          required: ["main_title"]
        }
      },
      required: ['movie']
    }
    post instances_path, headers: { 'Accept' => 'application/json' }, params: {schema: json_schema}
    assert_response :unauthorized
    assert_equal "You need to sign in or sign up before continuing.", JSON.parse(response.body)["error"]
  end
end
