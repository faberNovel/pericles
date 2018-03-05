module JSONSchema
  class AttributeDecorator < Draper::Decorator
    delegate_all

    def primitive_type
      (datetime? || date?) ? 'string' : object.primitive_type
    end

    def scheme
      return Scheme.new(name: 'datetime') if datetime?
      return Scheme.new(name: 'date') if date?
      object.scheme
    end
  end
end