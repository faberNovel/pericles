module JSONSchema
  class ResponseDecorator < Draper::Decorator
    delegate_all
    decorates_association :metadata_responses, with: JSONSchema::MetadataResponseDecorator

    def json_schema
      if resource_representation
        contextual_representation = JSONSchema::ResourceRepresentationDecorator.new(
          resource_representation, context: context
        )
      end

      json_schema_source = contextual_representation || api_error
      JSONSchemaBuilder.new(
        json_schema_source,
        is_collection: is_collection,
        root_key: root_key,
        metadata_responses: metadata_responses
      ).execute
    end
  end
end
