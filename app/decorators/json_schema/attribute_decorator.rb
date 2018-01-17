module JSONSchema
  class AttributeDecorator < Draper::Decorator
    delegate_all
    decorates_association :resource, with: JSONSchema::ResourceDecorator

    def primitive_type
      (datetime? || date?) ? :string : object.primitive_type
    end

    def scheme
      return Scheme.new(name: 'datetime') if datetime?
      return Scheme.new(name: 'date') if date?
      object.scheme
    end
  end
end