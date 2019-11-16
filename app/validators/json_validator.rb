class JsonValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.empty?
    JSON.parse(value) if value.is_a? String
  rescue JSON::ParserError
    record.errors.add(attribute, value_must_be_valid_json) if value.is_a? String
  end
end
