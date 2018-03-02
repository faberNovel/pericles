module JSONSchema
  class ResponseDecorator < Draper::Decorator
    delegate_all

    def json_schema
      contextual_representation = JSONSchema::ResourceRepresentationDecorator.new(
        resource_representation, context: context
      ) if resource_representation

      json_schema_source = contextual_representation || api_error
      JSONSchemaBuilder.new(
        json_schema_source,
        is_collection: is_collection,
        root_key: root_key,
        metadata: metadata,
      ).execute
    end
  end
end