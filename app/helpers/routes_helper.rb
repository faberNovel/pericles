module RoutesHelper
  def format_json(json)
    return if json.blank?
    JSON.pretty_generate(JSON.parse(json))
  end

  def get_http_method_label_class(route)
    case route.http_method.to_sym
    when :GET
      "label label-success http-method-label"
    when :POST
      "label label-warning http-method-label"
    when :PUT
      "label label-primary http-method-label"
    when :PATCH
      "label label-primary http-method-label"
    when :DELETE
      "label label-danger http-method-label"
    end
  end
end
