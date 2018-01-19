module JSONSchema
  class ResourceRepresentationDecorator < Draper::Decorator
    delegate_all
    decorates_association :attributes_resource_representations, with: JSONSchema::AttributesResourceRepresentationDecorator
    decorates_association :resource, with: JSONSchema::ResourceDecorator

    def hash
      object.hash
    end
  end
end