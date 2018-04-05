module ResponsesHelper
  def response_status_code_class(status_code)
    if status_code < 400
      'valid-response'
    else
      'invalid-response'
    end
  end

  def schema_summary(root_key, representation, is_collection)
    return '' if representation&.name.blank?

    summary = link_to(
      representation.name,
      project_resource_path(representation.resource.project, representation.resource, anchor: "rep-#{representation.id}")
    )

    summary = "[ #{summary} ]" if is_collection
    summary = "\"#{root_key}\": #{summary}" unless root_key.blank?
    summary = "{ #{summary} }" unless is_collection and root_key.blank?

    summary
  end
end
