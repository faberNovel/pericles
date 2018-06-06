module JSONSchema
  class ResponseDecorator < Draper::Decorator
    delegate_all

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
        metadata: metadata
      ).execute
    end
  end
end
