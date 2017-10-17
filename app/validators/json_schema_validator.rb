class JsonSchemaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value
    begin
      JSON::Validator.validate!("http://json-schema.org/draft-04/schema#", value, json: true)
    rescue JSON::Schema::JsonParseError, JSON::Schema::ValidationError => e
      record.errors.add(attribute, :schema_must_be_valid_json) if e.class == JSON::Schema::JsonParseError
      record.errors.add(attribute, :schema_must_respect_json_schema_spec, {error: e.message}) if e.class == JSON::Schema::ValidationError
    end
  end
end