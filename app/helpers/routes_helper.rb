module RoutesHelper
  def format_json_schema(json_schema)
    return if json_schema.blank?
    JSON.pretty_generate(JSON.parse(json_schema))
  end
end