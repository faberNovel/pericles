module JSONSchema
  class ResourceRepresentationDecorator < Draper::Decorator
    delegate_all

    def json_schema
      json_schema_without_definitions.merge({ definitions: definitions })
    end

    def json_schema_without_definitions
      # Clement Villain 2018-12-24
      # Cache can be stale for 30 seconds but it greatly improve performance (~30%)
      # for /projects/:id.json_schema
      Rails.cache.fetch(cache_key, expires_in: 30.seconds) do
        build_json_schema_without_definitions.deep_dup
      end
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
      return name if context[:use_resource_representation_name_as_uid]

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
        next if visited.map(&:id).include? representation.id

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

    def cache_key
      Digest::MD5.new << super << context.to_s
    end
  end
end
