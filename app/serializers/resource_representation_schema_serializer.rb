class ResourceRepresentationSchemaSerializer < ActiveModel::Serializer
  attributes :title, :type, :properties, :description, :required

  def initialize(object, options = {})
    @resource_representation = object
    @resource = object.resource
    @all_resource_representations = [@resource_representation.id]
    @required_properties = []
    @is_collection = options[:is_collection]
    @root_key = options[:root_key]
    super
  end

  def properties
    if @root_key.blank?
      properties_from_resource_representation(@resource_representation, @required_properties)
    else
      root_key_properties
    end
  end

  def required
    if @root_key.blank?
      required_properties
    else
      [@root_key]
    end
  end

  def description
    @resource.description
  end

  def type
    'object'
  end

  def title
    "#{@resource.name} - #{@resource_representation.name}"
  end

  private
  def root_key_properties
    resource_hash = {}
    resource_hash[:type] = 'object'
    resource_hash[:properties] = properties_from_resource_representation(@resource_representation, @required_properties)
    resource_hash[:required] = required_properties if required_properties
    properties_hash = {}
    if @is_collection
      array_of_attribute_hash = {}
      array_of_attribute_hash[:type] = 'array'
      array_of_attribute_hash[:items] = resource_hash
      properties_hash[@root_key] = array_of_attribute_hash
    else
      properties_hash[@root_key] = resource_hash
    end
    properties_hash
  end

  def required_properties
    @required_properties.uniq unless @required_properties.empty?
  end

  def properties_from_resource_representation(resource_representation, required_properties)
    properties = {}
    resource_representation.attributes_resource_representations.each do |association|
      properties[association.resource_attribute.name] = hash_from_attributes_resource_representation(association)
      required_properties << association.resource_attribute.name if association.is_required
    end
    return properties
  end

  def hash_from_attributes_resource_representation(association)
    attribute = association.resource_attribute
    attribute_hash = {}
    array_of_attribute_hash = nil
    if attribute.resource.present?
      resource_representation = association.resource_representation
      if cycle_detected(resource_representation)
        attribute_hash = set_main_fields_from_attribute(attribute)
      else
        @all_resource_representations << resource_representation.id
        attribute_hash = hash_from_attributes_resource_representation_with_child_resource_representation(association)
      end
    else
      attribute_hash = hash_from_primitive_attributes_resource_representation(association)
    end

    add_faker_data_to_attribute_hash(attribute_hash, association)

    if attribute.is_array
      array_of_attribute_hash = {}
      array_of_attribute_hash[:type] = 'array'
      array_of_attribute_hash[:items] = attribute_hash
    end

    hash_for_non_nullable_attribute = array_of_attribute_hash ? array_of_attribute_hash : attribute_hash

    is_nullable = association.custom_nullable.nil? ? attribute.nullable : association.custom_nullable

    return is_nullable ? { oneOf: [hash_for_non_nullable_attribute, { type: 'null' }] } : hash_for_non_nullable_attribute
  end

  def hash_from_attributes_resource_representation_with_child_resource_representation(association)
    attribute_hash = set_main_fields_from_attribute(association.resource_attribute)
    required_properties = []
    attribute_hash[:properties] = properties_from_resource_representation(association.resource_representation, required_properties)
    attribute_hash[:required] = required_properties.uniq unless required_properties.empty?
    return attribute_hash
  end

  def hash_from_primitive_attributes_resource_representation(association)
    attribute = association.resource_attribute
    attribute_hash = {}
    attribute_hash[:description] = attribute.description
    attribute_hash[:type] = attribute.primitive_type
    unless attribute.pattern.blank? && association.custom_pattern.blank?
      attribute_hash[:pattern] = association.custom_pattern.blank? ? attribute.pattern : association.custom_pattern
    end
    unless attribute.enum.blank? && association.custom_enum.blank?
      enum = association.custom_enum.blank? ? attribute.enum : association.custom_enum
      attribute_hash[:enum] = enum.split(", ")
      attribute_hash[:enum] = cast_enum_elements(attribute_hash[:enum], attribute_hash[:type]).uniq
    end
    [:min_length, :max_length, :minimum, :maximum].each do |attribute_name|
      unless attribute.send(attribute_name).blank?
        attribute_hash[attribute_name.to_s.camelize(:lower)] = attribute.send(attribute_name)
      end
    end
    return attribute_hash
  end

  def cycle_detected(resource_representation)
    return resource_representation.id.in?(@all_resource_representations)
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

  def add_faker_data_to_attribute_hash(attribute_hash, association)
    attribute = association.resource_attribute
    if association.faker_id?
      attribute_hash[:faker] = association.faker.name
    elsif attribute.faker_id?
      attribute_hash[:faker] = attribute.faker.name
    end
  end
end
