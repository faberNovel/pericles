module JSONSchema
  class AttributesResourceRepresentationDecorator < Draper::Decorator
    delegate_all
    decorates_association :resource_attribute, with: JSONSchema::AttributeDecorator
    decorates_association :resource_representation, with: JSONSchema::ResourceRepresentationDecorator

    def property
      return { type: 'null' } if is_null

      is_nullable = resource_attribute.nullable
      if is_nullable
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

    def non_nullable_property
      if resource_attribute.is_array
        {
          type: 'array',
          items: item_property,
          minItems: resource_attribute.min_items,
          maxItems: resource_attribute.max_items
        }
      else
        item_property
      end.merge(
        {
          description: resource_attribute.description
        }
      ).select { |_, v| v.present? }
    end

    def item_property
      if resource_representation.present?
        {
          type: 'object',
          '$ref': resource_representation.ref
        }
      else
        primitive_property
      end.select { |_, v| v.present? }
    end

    def primitive_property
      {
        type: resource_attribute.primitive_type,
        format: format,
        pattern: pattern,
        enum: enum
      }.merge(min_max_constraints)
    end

    def min_max_constraints
      if resource_attribute.string?
        {
          minLength: resource_attribute.minimum,
          maxLength: resource_attribute.maximum
        }
      else
        {
          minimum: resource_attribute.minimum,
          maximum: resource_attribute.maximum
        }
      end
    end

    def enum
      return if resource_attribute.enum.blank?

      enum_values = resource_attribute.enum.split(',').map(&:strip)
      case resource_attribute.primitive_type
      when 'integer'
        enum_values.map(&:to_i)
      when 'number'
        enum_values.map(&:to_f)
      when 'null'
        [nil]
      else
        enum_values
      end
    end

    def format
      resource_attribute.scheme.name if resource_attribute&.scheme&.format?
    end

    def pattern
      resource_attribute.scheme.regexp if resource_attribute&.scheme&.pattern?
    end
  end
end
