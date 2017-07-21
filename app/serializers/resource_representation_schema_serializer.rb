class ResourceRepresentationSchemaSerializer < ActiveModel::Serializer
  attributes :title, :type, :properties, :description, :required

  def initialize(object, options = {})
    @resource_representation = object
    @resource = object.resource
    @all_resource_representations = [@resource_representation.id]
    @required_properties = []
    @is_collection = options[:is_collection]
    super
  end

  def properties
    resource_hash = {}
    resource_hash[:type] = 'object'
    resource_hash[:properties] = properties_from_resource_representation(@resource_representation, @required_properties)
    resource_hash[:required] = @required_properties.uniq unless @required_properties.empty?
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

  def required
    @is_collection ? [@resource.name.downcase.pluralize] : [@resource.name.downcase]
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
    if attribute.is_array
      array_of_attribute_hash = {}
      if attribute.nullable
        attribute_hash[:oneOf] = [ {type: 'array' }, {type: 'null'} ]
      else
        attribute_hash[:type] = 'array'
      end
      array_of_attribute_hash[:items] = attribute_hash
      return array_of_attribute_hash
    else
      return attribute_hash
    end
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
    type_hash = {}
    attribute_hash[:description] = attribute.description
    type_hash[:type] = attribute.primitive_type
    unless attribute.pattern.blank? && association.custom_pattern.blank?
      type_hash[:pattern] = association.custom_pattern.blank? ? attribute.pattern : association.custom_pattern
    end
    unless attribute.enum.blank? && association.custom_enum.blank?
      enum = association.custom_enum.blank? ? attribute.enum : association.custom_enum
      type_hash[:enum] = enum.split(", ")
      type_hash[:enum] = cast_enum_elements(type_hash[:enum], type_hash[:type]).uniq
    end
    [:min_length, :max_length, :minimum, :maximum].each do |attribute_name|
      unless attribute.send(attribute_name).blank?
        type_hash[attribute_name.to_s.camelize(:lower)] = attribute.send(attribute_name)
      end
    end
    if attribute.nullable
      attribute_hash[:oneOf] = [type_hash, {type: 'null'} ]
    else
      attribute_hash.merge!(type_hash)
    end
    return attribute_hash
  end

  def cycle_detected(resource_representation)
    return resource_representation.id.in?(@all_resource_representations)
  end

  def set_main_fields_from_attribute(attribute)
    attribute_hash = {}
    if attribute.nullable
      attribute_hash[:oneOf] = [ {type: 'object'}, {type: 'null'} ]
    else
      attribute_hash[:type] = 'object'
    end
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