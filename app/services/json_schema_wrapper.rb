class JSONSchemaWrapper
  def initialize(json_schema, root_key, is_collection)
    @json_schema = json_schema.is_a?(String) ? JSON.parse(json_schema) : json_schema
    @json_schema.deep_symbolize_keys!
    @root_key = root_key
    @is_collection = is_collection
  end

  def execute
    definitions = @json_schema.delete :definitions
    title = @json_schema.delete :title
    description = @json_schema.delete :description

    @json_schema = {type: 'array', items: @json_schema } if @is_collection
    @json_schema = {
      type: 'object',
      properties: {@root_key.to_sym => @json_schema},
      required: [@root_key.to_s],
      additionalProperties: false
    } unless @root_key.blank?

    @json_schema[:definitions] = definitions unless definitions.blank?
    @json_schema[:title] = title unless title.blank?
    @json_schema[:description] = description unless description.blank?
    @json_schema
  end
end