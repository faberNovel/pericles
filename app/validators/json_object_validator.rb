
class JsonObjectValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add(attribute, :json_object_cannot_be_blank)
      return
    end

    begin
      parsed_json = JSON.parse(value)
    rescue JSON::ParserError
      record.errors.add(attribute, :could_not_parse_json)
      return
    end

    unless parsed_json.is_a? Hash
      record.errors.add(attribute, :json_must_be_an_object)
      return
    end
  end
end
