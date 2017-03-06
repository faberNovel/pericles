class JsonSchema < ApplicationRecord
  belongs_to :project

  validates :name, presence: true, :uniqueness => {:scope => [:project]}
  validates :schema, presence: true
  validates :project, presence: true
  validate :schema_must_be_valid

  private

  def schema_must_be_valid
    return unless schema
    begin
      JSON::Validator.validate!("http://json-schema.org/draft-04/schema#", schema, :json => true)
    rescue JSON::Schema::JsonParseError, JSON::Schema::ValidationError => e
      errors.add(:schema, :schema_must_be_valid_json) if e.class == JSON::Schema::JsonParseError
      errors.add(:schema, :schema_must_respect_json_schema_spec, {error: e.message}) if e.class == JSON::Schema::ValidationError
    end
  end
end
