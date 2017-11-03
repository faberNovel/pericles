module ResponsesHelper
  def response_status_code_class(status_code)
    if status_code < 400
      'valid-response'
    else
      'invalid-response'
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
