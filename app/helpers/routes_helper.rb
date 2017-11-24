module RoutesHelper
  def format_json(json)
    return if json.blank?
    json = JSON.parse(json) if json.is_a?(String)
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
end
