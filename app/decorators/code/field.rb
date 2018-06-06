module Code
  module Field
    extend ActiveSupport::Concern

    def variable_name
      name.parameterize(separator: '_', preserve_case: true).camelcase(:lower)
    end

    def kotlin_type
      type = base_kotlin_type
      type = "List<#{type}>" if is_array
      type = "#{type}?" if code_nullable
      type
    end

    def java_type
      type = base_java_type
      type = "List<#{type}>" if is_array
      type = "@Nullable #{type}" if code_nullable
      type
    end

    def swift_type
      type = base_swift_type
      type = "[#{type}]" if is_array
      type = "#{type}?" if code_nullable
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
      when :date
        'String'
      when :datetime
        'String'
      when nil
        resource.rest_name
      end
    end

    def base_java_type
      base_kotlin_type.gsub(/^Int$/, 'Integer')
    end

    def base_swift_type
      case primitive_type&.to_sym
      when :number
        'Double'
      when :integer
        'Int'
      when :boolean
        'Bool'
      when :string
        'String'
      when :date
        'Date'
      when :datetime
        'Date'
      when nil
        resource.rest_name
      end
    end
  end
end
