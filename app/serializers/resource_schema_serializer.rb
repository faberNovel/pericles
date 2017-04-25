class ResourceSchemaSerializer < ActiveModel::Serializer
  attributes :title, :type, :properties, :description

  def initialize(object, options = {})
    @resource = object.resource
    @all_resources = [@resource.id]
    super
  end

  def properties
    resource_hash = {}
    resource_hash[:type] = 'object'
    resource_hash[:properties] = properties_from_resource(@resource)
    properties_hash = {}
    properties_hash[@resource.name.downcase] = resource_hash
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
  def properties_from_resource(resource)
    properties = {}
    resource.resource_attributes.each do |attribute|
      properties[attribute.name] = hash_from_attribute(attribute)
    end
    return properties
  end

  def hash_from_attribute(attribute)
    attribute_hash = {}
    if attribute.resource.present?
      if cycle_detected(attribute)
        attribute_hash = set_main_fields_from_attribute(attribute)
      else
        attribute_hash = hash_from_resource_attribute(attribute)
        @all_resources << attribute.resource.id
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
    attribute_hash[:properties] = properties_from_resource(attribute.resource)
    return attribute_hash
  end

  def hash_from_primitive_attribute(attribute)
    attribute_hash = {}
    attribute_hash[:type] = attribute.primitive_type
    attribute_hash[:description] = attribute.description
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

end