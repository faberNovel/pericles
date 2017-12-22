class ResourceDecorator < Draper::Decorator
  delegate_all

  def rest_name
    "Rest#{name.camelcase}"
  end

  def should_import_nullable_annotation
    resource_attributes.any?(&:nullable)
  end

  def should_import_java_list
    resource_attributes.any?(&:is_array)
  end
end