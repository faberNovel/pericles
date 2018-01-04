module JSONSchema
  class ResourceDecorator < Draper::Decorator
    delegate_all
    decorates_association :resource_attributes, with: JSONSchema::AttributeDecorator
    decorates_association :resource_representation, with: JSONSchema::ResourceRepresentationDecorator
  end
end