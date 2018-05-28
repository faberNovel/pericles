module JSONSchema
  class ResourceRepresentationDecorator < Draper::Decorator
    delegate_all

    def json_schema
      json_schema_without_definitions.merge({ definitions: definitions })
    end

    def json_schema_without_definitions
      # TODO: Clement Villain 28/05/2018
      # Build a cache system
      build_json_schema_without_definitions
    end

    def build_json_schema_without_definitions
      schema = {
        title: title,
        type: 'object',
        properties: properties,
        additionalProperties: false
      }
      schema[:description] = description if description.present?
      schema[:required] = required unless required.empty?

      schema
    end

    def properties
      properties_hash = {}
      attributes_resource_representations.each do |association|
        association = JSONSchema::AttributesResourceRepresentationDecorator.new(
          association, context: context
        )
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
      "#{base_href}#{uid}"
    end

    def base_href
      context[:base_href] || '#/definitions/'
    end

    def uid
      name = object.name.tr(' ', '_')
      id = object.id || object.hash.abs
      "#{name}_#{id}"
    end

    def required
      attributes_resource_representations
        .select(&:is_required)
        .map(&:key_name)
        .uniq
        .sort # We sort to generate a stable json schema
    end

    def title
      "#{object.resource.name} - #{object.name}"
    end

    def resource_representation_dependencies
      visited = Set.new

      queue = next_representation_dependencies(object)
      until queue.empty?
        representation = queue.pop
        next if visited.include? representation

        visited << JSONSchema::ResourceRepresentationDecorator.new(
          representation, context: context
        )
        queue += next_representation_dependencies(representation)
      end

      visited
    end

    def next_representation_dependencies(representation)
      representation.attributes_resource_representations
        .includes(
          resource_representation: {
            attributes_resource_representations: :resource_attribute,
            resource: nil
          }
        ).map(&:resource_representation).compact
    end
  end
end
