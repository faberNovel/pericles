class MockInstance < ApplicationRecord
  belongs_to :response

  validate :body_must_comply_with_response_json_schema

  private

  def body_must_comply_with_response_json_schema
    JSON::Validator.fully_validate(
      response.json_schema, body, json: true
    ).each do |error_message|
      errors.add(:body, error_message)
    end if response.json_schema
  end
end
