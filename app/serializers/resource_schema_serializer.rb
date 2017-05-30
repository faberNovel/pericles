class ResourceSchemaSerializer < ActiveModel::Serializer
  attributes :title, :type, :properties, :description

  def initialize(object, options = {})
    @resource = object.resource
    @all_resources = [@resource.id]
    @is_collection = object.is_restful_collection?
    super
  end

  def properties
    resource_hash = {}
    resource_hash[:type] = 'object'
    required_properties = []
    resource_hash[:properties] = properties_from_resource(@resource, required_properties)
    resource_hash[:required] = required_properties.uniq unless required_properties.empty?
    properties_hash = {}
    if @is_collection
      array_of_attribute_hash = {}
      array_of_attribute_hash[:type] = 'array'
      array_of_attribute_hash[:items] = resource_hash
      properties_hash[@resource.name.downcase.pluralize] = array_of_attribute_hash
    else
      properties_hash[@resource.name.downcase] = resource_hash
    end
    return properties_hash
  end

  def description
    @resource.description
  end

  def type
    'object'
  end

  def title
    @resource.name
  end

  private
  def properties_from_resource(resource, required_properties)
    properties = {}
    resource.resource_attributes.each do |attribute|
      properties[attribute.name] = hash_from_attribute(attribute)
      required_properties.concat([attribute.name]) if attribute.is_required
    end
    return properties
  end

  def hash_from_attribute(attribute)
    attribute_hash = {}
    if attribute.resource.present?
      if cycle_detected(attribute)
        attribute_hash = set_main_fields_from_attribute(attribute)
      else
        @all_resources << attribute.resource.id
        attribute_hash = hash_from_resource_attribute(attribute)
      end
    else
      attribute_hash = hash_from_primitive_attribute(attribute)
    end
    if attribute.is_array
      array_of_attribute_hash = {}
      array_of_attribute_hash[:type] = 'array'
      array_of_attribute_hash[:items] = attribute_hash
      return array_of_attribute_hash
    else
      return attribute_hash
    end
  end

  def hash_from_resource_attribute(attribute)
    attribute_hash = set_main_fields_from_attribute(attribute)
    required_properties = []
    attribute_hash[:properties] = properties_from_resource(attribute.resource, required_properties)
    attribute_hash[:required] = required_properties.uniq unless required_properties.empty?
    return attribute_hash
  end

  def hash_from_primitive_attribute(attribute)
    attribute_hash = {}
    attribute_hash[:type] = attribute.primitive_type
    attribute_hash[:description] = attribute.description
    unless attribute.pattern.blank?
      attribute_hash[:pattern] = attribute.pattern
    end
    unless attribute.enum.blank?
      attribute_hash[:enum] = attribute.enum.split(", ")
      attribute_hash[:enum] = cast_enum_elements(attribute_hash[:enum], attribute_hash[:type]).uniq
    end
    return attribute_hash
  end

  def cycle_detected(attribute)
    return attribute.resource.id.in?(@all_resources)
  end

  def set_main_fields_from_attribute(attribute)
    attribute_hash = {}
    attribute_hash[:type] = 'object'
    attribute_hash[:title] = attribute.resource.name
    attribute_hash[:description] = attribute.description
    return attribute_hash
  end

  def cast_enum_elements(enum, attribute_primitive_type)
    case attribute_primitive_type
    when "integer"
      enum.collect(&:to_i)
    when "number"
      enum.collect(&:to_f)
    when "null"
      [nil]
    else
      enum
    end
  end

end
