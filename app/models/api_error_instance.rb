class ApiErrorInstance < ApplicationRecord
  belongs_to :api_error

  has_and_belongs_to_many :mock_pickers

  validates :name, presence: true
  validate :body_must_comply_with_api_error_json_schema

  def as_json
    JSON.parse(body)
  end

  private

  def body_must_comply_with_api_error_json_schema
    return unless api_error.json_schema

    JSON::Validator.fully_validate(
      api_error.json_schema, body, json: true
    ).each do |error_message|
      errors.add(:body, error_message)
    end
  end

end
