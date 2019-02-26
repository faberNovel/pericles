class JSONSchemaWrapper
  def initialize(json_schema, root_key, is_collection, metadata_responses)
    @json_schema = json_schema.is_a?(String) ? JSON.parse(json_schema) : json_schema
    @json_schema.deep_symbolize_keys!
    @root_key = root_key
    @is_collection = is_collection
    @metadata_responses = metadata_responses
  end

  def execute
    definitions = @json_schema.delete :definitions
    title = @json_schema.delete :title
    description = @json_schema.delete :description

    @json_schema = { type: 'array', items: @json_schema } if @is_collection
    if @root_key.present?
      @json_schema = {
        type: 'object',
        properties: { @root_key.to_sym => @json_schema },
        required: [@root_key.to_s],
        additionalProperties: false
      }
    end
    add_metadata if should_add_metadata

    @json_schema[:definitions] = definitions if definitions.present?
    @json_schema[:title] = title if title.present?
    @json_schema[:description] = description if description.present?
    @json_schema
  end

  private

  def should_add_metadata
    json_is_array = @is_collection && @root_key.blank?
    !@metadata_responses.empty? && !json_is_array
  end

  def add_metadata
    @metadata_responses.group_by(&:key).each do |key, metadata_responses|
      metadata_responses.map(&:metadatum).each do |metadatum|
        schema = metadatum.json_schema
        if key.blank?
          properties = @json_schema[:properties]
        else
          @json_schema[:properties][key.to_sym] ||= { type: 'object', properties: {} }
          properties = @json_schema[:properties][key.to_sym][:properties]
        end
        properties[metadatum.name.to_sym] = schema
      end
    end
  end
end
