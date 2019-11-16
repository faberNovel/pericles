module ValidationsHelper
  def validation_string_for_status(status)
    t("activerecord.attributes.validation.status.#{status}")
  end

  def format_json_text(text)
    parsed_json = JSON.parse(text)
    JSON.stable_pretty_generate(parsed_json)
  rescue JSON::ParserError
    text
  end

  def self.parse_json_text(text)
    if text.is_a? String
      begin
        JSON.parse(text)
      rescue JSON::ParserError
        text
      end
    else
      text
    end
  end
end
