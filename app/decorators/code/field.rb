module Code
  module Field
    extend ActiveSupport::Concern

    def camel_variable_name
      name.parameterize(separator: '_', preserve_case: true).camelcase(:lower)
    end

    def snake_variable_name
      name.underscore
    end

    def kotlin_type
      type = base_kotlin_type
      type = "List<#{type}>" if is_array
      type = "#{type}?" if code_nullable
      type
    end

    def swift_type
      type = base_swift_type
      type = "[#{type}]" if is_array
      type = "#{type}?" if code_nullable
      type
    end

    def typescript_type
      type = base_typescript_type
      type = "ReadonlyArray<#{type}>" if is_array
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

    def base_typescript_type
      case primitive_type&.to_sym
      when :number
        'number'
      when :integer
        'number'
      when :boolean
        'boolean'
      when :string
        if enum.blank?
          'string'
        else
          enum.split(',').map { |x| "\"#{x.strip}\"" }.join(' | ')
        end
      when :date
        'string'
      when :datetime
        'string'
      when :object
        'object'
      when :any
        'any'
      when nil
        resource.rest_name
      end
    end

    def typescript_assignment
      json_value = "json.#{key_name}"
      output = typescript_output(json_value)
      output = typescript_nullable_output(output, json_value) if code_nullable

      "this.#{camel_variable_name} = #{output};\n"
    end

    private

    def typescript_nullable_output(output, json_value)
      if !is_array && boolean?
        "#{output} !== undefined && #{output} !== null && #{output}"
      else
        "(#{json_value} !== null && #{json_value} !== undefined) ? #{output} : undefined"
      end
    end

    def typescript_output(json_value)
      if primitive_type
        json_value
      else
        type = base_typescript_type.sub(/^Rest/, '')
        if is_array
          "#{json_value}.map((o) => new #{type}(o))"
        else
          "new #{type}(#{json_value})"
        end
      end
    end
  end
end
