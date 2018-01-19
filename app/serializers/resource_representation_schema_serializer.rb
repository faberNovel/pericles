class ResourceRepresentationSchemaSerializer < ActiveModel::Serializer
  attributes :title, :type, :definitions
  attribute :properties, if: :properties?
  attribute :items, if: :items?
  attribute :required, if: :required?
  attribute :description, if: :description?
  attribute :additionalProperties

  def initialize(object, options = {})
    @resource_representation = JSONSchema::ResourceRepresentationDecorator.new(object)
    @resource = object.resource
    @is_collection = options[:is_collection]
    @root_key = options[:root_key]
    super
  end

  def additionalProperties
    false
  end

  def properties?
    !items?
  end

  def properties
    if @root_key.blank?
      properties_from_resource_representation(@resource_representation)
    else
      root_key_properties
    end
  end

  def required?
    # see https://github.com/json-schema-faker/json-schema-faker/issues/338
    (!@root_key.blank? || !@is_collection) && !required.empty?
  end

  def required
    if @root_key.blank? && !@is_collection
      required_from_resource_representation(@resource_representation)
    elsif !@root_key.blank?
      [@root_key]
    end
  end

  def description?
    !description.blank?
  end

  def description
    @resource.description
  end

  def type
    items? ? 'array' : 'object'
  end

  def items?
    @is_collection && @root_key.blank?
  end

  def items
    build_resource_hash(@resource_representation)
  end

  def title
    "#{@resource.name} - #{@resource_representation.name}"
  end

  def definitions
    hash = {}
    all_resource_representations.each do |resource_representation|
      hash[uid(resource_representation)] = build_resource_hash(resource_representation)
    end
    hash
  end

  private
  def root_key_properties
    resource_hash = build_resource_hash(@resource_representation)
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

  def build_resource_hash(resource_representation)
    resource_hash = {}
    resource_hash[:type] = 'object'
    resource_hash[:properties] = properties_from_resource_representation(resource_representation)
    resource_hash[:additionalProperties] = false
    add_required_if_not_empty(resource_hash, resource_representation)
    resource_hash
  end

  def add_required_if_not_empty(resource_hash, resource_representation)
    required = required_from_resource_representation(resource_representation)
    resource_hash[:required] = required unless required.empty?
  end

  def required_from_resource_representation(resource_representation)
    resource_representation.attributes_resource_representations.select(&:is_required).map do |attr_resource_rep|
        attr_resource_rep.key_name
    end.uniq
  end

  def properties_from_resource_representation(resource_representation)
    properties = {}
    resource_representation.attributes_resource_representations.each do |association|
      properties[association.key_name] = hash_from_attributes_resource_representation(association)
    end
    return properties
  end

  def hash_from_attributes_resource_representation(association)
    return { type: 'null' } if association.is_null

    attribute = association.resource_attribute
    attribute_hash = {}
    array_of_attribute_hash = nil
    if attribute.resource.present?
      resource_representation = association.resource_representation
      attribute_hash = {type: 'object', "$ref": ref(resource_representation)}
    else
      attribute_hash = hash_from_primitive_attributes_resource_representation(association)
    end

    add_faker_data_to_attribute_hash(attribute_hash, association)

    if attribute.is_array
      array_of_attribute_hash = {}
      array_of_attribute_hash[:type] = 'array'
      array_of_attribute_hash[:items] = attribute_hash
      add_array_minmax_constraints(array_of_attribute_hash, attribute)
    end

    hash_for_non_nullable_attribute = array_of_attribute_hash ? array_of_attribute_hash : attribute_hash

    is_nullable = attribute.nullable

    return is_nullable ? { oneOf: [hash_for_non_nullable_attribute, { type: 'null' }] } : hash_for_non_nullable_attribute
  end

  def hash_from_attributes_resource_representation_with_child_resource_representation(association)
    attribute_hash = set_main_fields_from_attribute(association.resource_attribute)
    attribute_hash[:properties] = properties_from_resource_representation(association.resource_representation)
    attribute_hash[:additionalProperties] = false
    add_required_if_not_empty(attribute_hash, association.resource_representation)
    return attribute_hash
  end

  def hash_from_primitive_attributes_resource_representation(association)
    attribute = association.resource_attribute
    attribute_hash = {}
    attribute_hash[:description] = attribute.description unless attribute.description.blank?
    attribute_hash[:type] = attribute.primitive_type
    add_scheme_validation(attribute_hash, association)
    unless attribute.enum.blank?
      enum = attribute.enum
      attribute_hash[:enum] = enum.split(',').map(&:strip)
      attribute_hash[:enum] = cast_enum_elements(attribute_hash[:enum], attribute_hash[:type]).uniq
    end
    add_primitive_minmax_constraints(attribute_hash, attribute)
    return attribute_hash
  end

  def add_scheme_validation(attribute_hash, association)
    scheme = association.resource_attribute.scheme
    attribute_hash[:format] = scheme.name if scheme&.format?
    attribute_hash[:pattern] = scheme.regexp if scheme&.pattern?
  end

  def set_main_fields_from_attribute(attribute)
    attribute_hash = {}
    attribute_hash[:type] = 'object'
    attribute_hash[:title] = attribute.resource.name
    attribute_hash[:description] = attribute.description unless attribute.description.blank?
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
    if attribute.faker_id?
      attribute_hash[:faker] = attribute.faker.name
    end
  end

  def add_array_minmax_constraints(hash, attribute)
    [:min_items, :max_items].each do |attribute_name|
      constraint_value = attribute.send(attribute_name)
      next if constraint_value.blank?

      key = attribute_name.to_s.camelize(:lower)
      hash[key] = constraint_value
    end
  end

  def add_primitive_minmax_constraints(hash, attribute)
    [:minimum, :maximum].each do |attribute_name|
      constraint_value = attribute.send(attribute_name)
      next if constraint_value.blank?

      key = minmax_key_name(attribute_name, attribute)
      hash[key] = constraint_value
    end
  end

  def minmax_key_name(minmax_name, attribute)
    if attribute.string?
      minmax_name[0..2] + 'Length'
    else
      minmax_name
    end
  end

  def uid(model)
    name = model.name.gsub(' ', '_')
    id = model.id || model.hash.abs
    "#{name}_#{id}"
  end

  def ref(representation)
    "#/definitions/#{uid(representation)}"
  end

  def all_resource_representations
    return @all_resource_representations if defined? @all_resource_representations
    representations = @resource_representation.resource_representation_dependencies
    @all_resource_representations = representations.map do |r|
      JSONSchema::ResourceRepresentationDecorator.new(r)
    end
  end
end
