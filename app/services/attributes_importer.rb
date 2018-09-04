class AttributesImporter
  def initialize(resource)
    @resource = resource
    @resources = resource.project.resources
  end

  def import_from_json_instance(json)
    hash = parse_json(json)
    return unless hash
    create_attributes_from_json_hash(hash)
  end

  private

  def create_attributes_from_json_hash(hash)
    hash.each do |key, value|
      if value.class <= Array
        next if value.map(&:class).uniq.count != 1
        cls = value.first.class
        create_attribute_from_class(key, cls, value.first, true)
      else
        create_attribute_from_class(key, value.class, value, false)
      end
    end
  end

  def create_attribute_from_class(key, cls, value, is_array)
    if cls <= Hash
      resource = @resources.detect do |r|
        key.to_s.camelize.pluralize == r.name.camelize.pluralize
      end
      resource ||= @resources.sort_by { |r| r.name.length }.reverse.detect do |r|
        key.to_s.camelize.pluralize.include? r.name.camelize.pluralize
      end
      @resource.resource_attributes.create(name: key, resource: resource, is_array: is_array)
    else
      create_attribute_from_primitive_class(key, cls, value, is_array)
    end
  end

  def create_attribute_from_primitive_class(key, primitive_class, value, is_array)
    if primitive_class <= Integer
      @resource.resource_attributes.create(
        name: key, primitive_type: :integer, is_array: is_array
      )
    elsif primitive_class <= String
      create_attribute_from_string(value, is_array, key)
    elsif primitive_class <= TrueClass || primitive_class <= FalseClass
      @resource.resource_attributes.create(
        name: key, primitive_type: :boolean, is_array: is_array
      )
    elsif primitive_class <= Float
      @resource.resource_attributes.create(
        name: key, primitive_type: :number, is_array: is_array
      )
    elsif primitive_class <= NilClass
      @resource.resource_attributes.create(
        name: key, primitive_type: :null, is_array: is_array, nullable: true
      )
    end
  end

  def create_attribute_from_string(value, is_array, key)
    if datetime?(value)
      primitive_type = :datetime
    elsif date?(value)
      primitive_type = :date
    else
      primitive_type = :string
    end
    @resource.resource_attributes.create(
      name: key, primitive_type: primitive_type, is_array: is_array
    )
  end

  def datetime?(value)
    begin
      DateTime.iso8601(value).to_s && value.length > 10
    rescue ArgumentError
      false
    end
  end

  def date?(value)
    begin
      Date.iso8601(value).to_s && value.length <= 10
    rescue ArgumentError
      false
    end
  end

  def parse_json(json)
    begin
      parsed_json = JSON.parse(json)
    rescue JSON::ParserError
      return
    end

    return parsed_json if parsed_json.is_a? Hash
  end
end
