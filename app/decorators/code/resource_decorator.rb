class Code::ResourceDecorator < Draper::Decorator
  delegate_all

  def rest_name
    "Rest#{name.parameterize(separator: '_', preserve_case: true).camelcase}"
  end

  def kotlin_filename
    "#{rest_name}.kt"
  end

  def java_filename
    "#{rest_name}.java"
  end

  def swift_filename
    "#{rest_name}.swift"
  end

  def should_import_nullable_annotation
    resource_attributes.any?(&:nullable)
  end

  def should_import_java_list
    resource_attributes.any?(&:is_array)
  end

  def resource_attributes
    @resource_attributes ||= object.resource_attributes.map do |a|
      Code::AttributeDecorator.new(a)
    end.sort_by(&:variable_name)
  end

  def nullable_attributes
    @nullable_attributes ||= resource_attributes.select(&:code_nullable)
  end

  def mandatory_attributes
    @mandatory_attributes ||= resource_attributes.reject(&:code_nullable)
  end
end