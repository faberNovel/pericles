module RoutesHelper
  def format_json(json)
    return if json.blank?
    json = JSON.parse(json) unless json.is_a?(Hash)
    JSON.pretty_generate(json)
  end

  def label_class_for_http_method(http_method)
    case http_method&.to_sym
    when :GET
      "label label-success http-method-label"
    when :POST
      "label label-warning http-method-label"
    when :PUT
      "label label-primary http-method-label"
    when :PATCH
      "label label-primary http-method-label"
    when :OPTIONS
      "label label-warning http-method-label"
    when :DELETE
      "label label-danger http-method-label"
    end
  end

  def schema_summary(root_key, name, is_collection)
    return '' if name.blank?
    name = "[ #{name} ]" if is_collection
    name = "\"#{root_key}\": #{name}" unless root_key.blank?
    name = "{ #{name} }" unless is_collection and root_key.blank?
    return name
  end
end
