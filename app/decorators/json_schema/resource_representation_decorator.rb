module JSONSchema
  class ResourceRepresentationDecorator < Draper::Decorator
    delegate_all
    decorates_association :attributes_resource_representations, with: JSONSchema::AttributesResourceRepresentationDecorator
    decorates_association :resource, with: JSONSchema::ResourceDecorator

    def json_schema
      json_schema_without_definitions.merge({definitions: definitions})
    end

    def json_schema_without_definitions
      schema = {
        title: title,
        type: 'object',
        properties: properties,
        additionalProperties: false,
      }
      schema[:description] = description unless description.blank?
      schema[:required] = required unless required.empty?

      schema
    end

    def properties
      properties_hash = {}
      attributes_resource_representations.each do |association|
        properties_hash[association.key_name] = association.property
      end
      properties_hash
    end

    def definitions
      definitions_hash = {}
      resource_representation_dependencies.each do |r|
        definitions_hash[r.uid] = r.json_schema_without_definitions
      end
      definitions_hash
    end

    def ref
      "#/definitions/#{uid}"
    end

    def uid
      name = object.name.gsub(' ', '_')
      id = object.id || object.hash.abs
      "#{name}_#{id}"
    end

    def required
      attributes_resource_representations
        .select(&:is_required)
        .map { |attr_resource_rep| attr_resource_rep.key_name }
        .uniq
        .sort # We sort to generate a stable json schema
    end

    def title
      "#{object.resource.name} - #{object.name}"
    end

    def resource_representation_dependencies
      object.resource_representation_dependencies.map do |r|
        JSONSchema::ResourceRepresentationDecorator.new(r)
      end
    end
  end
end