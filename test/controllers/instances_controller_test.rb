require 'test_helper'

class InstancesControllerTest < ActionDispatch::IntegrationTest

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
              enum: ["The Godfather", "Finding Nemo"],
              pattern: "The Godfather II"
            }
          },
          required: ["main_title"]
        }
      },
      required: ['movie']
    }
    post instances_path, params: {schema: json_schema}
    assert_response :success
    assert JSON::Validator.validate(@response.body, json_schema), "json generated should match json schema"
  end
end
