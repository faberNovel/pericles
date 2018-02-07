module ValidationsHelper
  def validation_string_for_status(status)
    t("activerecord.attributes.validation.status.#{status}")
  end

  def format_json_text(text)
    begin
      parsed_json = JSON.parse(text)
      JSON.stable_pretty_generate(parsed_json)
    rescue JSON::ParserError
      text
    end
  end
end