class JSONSchemaWrapper
  def initialize(json_schema, root_key, is_collection, metadata)
    @json_schema = json_schema.is_a?(String) ? JSON.parse(json_schema) : json_schema
    @json_schema.deep_symbolize_keys!
    @root_key = root_key
    @is_collection = is_collection
    @metadata = metadata
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
    add_metadata if should_add_metadata

    @json_schema[:definitions] = definitions unless definitions.blank?
    @json_schema[:title] = title unless title.blank?
    @json_schema[:description] = description unless description.blank?
    @json_schema
  end

  private

  def should_add_metadata
    json_is_array = @is_collection && @root_key.blank?
    !@metadata.empty? && !json_is_array
  end

  def add_metadata
    metadata_properties = {}
    @metadata.each do |md|
      metadata_properties[md.name.to_sym] = { type: md.primitive_type }
    end

    @json_schema[:properties].merge!(metadata_properties)
  end
end