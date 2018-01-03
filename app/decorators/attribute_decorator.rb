class AttributeDecorator < Draper::Decorator
  delegate_all

  def variable_name
    name.parameterize(separator: '_', preserve_case: true).camelcase(:lower)
  end

  def key_name_placeholder
    name.underscore.parameterize(separator: '_')
  end

  def kotlin_type
    type = base_kotlin_type
    type = "List<#{type}>" if is_array
    type = "#{type}?" if nullable
    type
  end

  def java_type
    type = base_java_type
    type = "List<#{type}>" if is_array
    type = "@Nullable #{type}" if nullable
    type
  end

  def swift_type
    type = base_swift_type
    type = "[#{type}]" if is_array
    type = "#{type}?" if nullable
    type
  end

  def swift_deserialize_code
    json_value = "json[\"#{object.default_key_name}\"]"
    if is_array
      "#{json_value}.arrayValue.flatMap { #{base_swift_deserialize('$0')} }"
    else
      base_swift_deserialize(json_value)
    end
  end

  def base_kotlin_type
    case primitive_type&.to_sym
    when :number
      'Double'
    when :integer
      'Int'
    when :boolean
      'Boolean'
    when :string
      'String'
    when nil
      resource.decorate.rest_name
    end
  end

  def base_java_type
    base_kotlin_type.gsub(/^Int$/, 'Integer')
  end

  def base_swift_type
    base_kotlin_type
  end

  def base_swift_deserialize(var)
    return "#{resource.decorate.rest_name}(json: #{var})" if primitive_type.nil?

    case primitive_type&.to_sym
    when :number
      "#{var}.double"
    when :integer
      "#{var}.int"
    when :boolean
      "#{var}.bool"
    when :string
      "#{var}.string"
    end + (nullable ? 'Value' : '')
  end
end