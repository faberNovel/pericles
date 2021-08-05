module JSONSchema
  class MetadatumDecorator < Draper::Decorator
    delegate_all

    def json_schema
      non_nullable_property = (datetime? || date?) ? { type: :string, format: primitive_type } : { type: primitive_type }
      if nullable
        if should_use_nullable
          non_nullable_property.merge(nullable: true)
        else
          { anyOf: [non_nullable_property, { type: 'null' }] }
        end
      else
        non_nullable_property
      end
    end

    def should_use_nullable
      context[:use_nullable]
    end
  end
end
