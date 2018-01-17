class Validation < ApplicationRecord
  def status
    if json_schema_errors.any?
      json_schema_errors.first[:description] == "parse_error" ? :schema_parse_error : :schema_validation_error
    elsif json_instance_errors.any?
      json_instance_errors.first[:description] == "parse_error" ? :instance_parse_error : :instance_validation_error
    else
      :success
    end
  end

  def json_errors
    @json_errors ||= json_schema_errors + json_instance_errors
  end

  def json_instance_errors
    @json_instance_errors ||= instance_errors.map { |e| { description: e } }
  end

  def json_schema_errors
    @json_schema_errors ||= schema_errors.map { |e| { description: e } }
  end

  private

  def schema_errors
    @schema_errors ||= validate_json_schema
  end

  def instance_errors
    @instance_errors ||= schema_errors.empty? ? validate_json_instance : []
  end

  def validate_json_schema
    validate_json(META_SCHEMA, json_schema)
  end

  def validate_json_instance
    validate_json(json_schema, json_instance)
  end

  def validate_json(schema, json)
    errors = []
    begin
      errors = JSON::Validator.fully_validate(schema, json, json: true)
    rescue JSON::Schema::JsonParseError, TypeError
      errors << "parse_error"
    end
    errors
  end
end
