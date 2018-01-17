module JSONSchema
  class AttributesResourceRepresentationDecorator < Draper::Decorator
    delegate_all
    decorates_association :resource_attribute, with: JSONSchema::AttributeDecorator
  end
end