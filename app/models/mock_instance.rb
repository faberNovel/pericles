class MockInstance < ApplicationRecord
  belongs_to :resource

  has_and_belongs_to_many :mock_pickers

  validates :name, presence: true
  validate :body_must_comply_with_resource_json_schema

  def body_sliced_with(resource_representation)
    SliceJSONWithResourceRepresentation.new(JSON.parse(body), resource_representation).execute
  end

  private

  def body_must_comply_with_resource_json_schema
    return unless resource.json_schema

    JSON::Validator.fully_validate(
      resource.json_schema, body, json: true
    ).each do |error_message|
      errors.add(:body, error_message)
    end
  end
end
