class AttributeDecorator < Draper::Decorator
  delegate_all

  def key_name_placeholder
    name.underscore.parameterize(separator: '_')
  end

  def readable_type
    base_type = resource&.name || primitive_type.to_s.capitalize
    is_array ? "Array<#{base_type}>" : base_type
  end

  def displayed_type
    if resource_id
      project = attribute.resource.project
      h.link_to(
        readable_type,
        h.project_resource_path(project, attribute.resource),
        'resource-name': readable_type
      )
    else
      readable_type
    end
  end

  def constraints?
    !(
      attribute.enum.blank? &&
      attribute.scheme.blank? &&
      attribute.minimum.blank? &&
      attribute.maximum.blank? &&
      attribute.description.blank?
    )
  end
end