module JSONSchema
  class AttributeDecorator < Draper::Decorator
    delegate_all

    def primitive_type
      if datetime? || date?
        'string'
      else
        object.primitive_type
      end
    end

    def scheme
      return Scheme.new(name: 'datetime') if datetime?
      return Scheme.new(name: 'date') if date?
      object.scheme
    end
  end
end
