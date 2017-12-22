class AttributeDecorator < Draper::Decorator
  delegate_all

  def variable_name
    name.camelcase(:lower)
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
end