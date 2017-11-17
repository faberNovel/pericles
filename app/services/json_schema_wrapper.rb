class JSONSchemaWrapper
  def initialize(json_schema, root_key, is_collection)
    @json_schema = json_schema.is_a?(String) ? JSON.parse(json_schema) : json_schema
    @root_key = root_key
    @is_collection = is_collection
  end

  def execute
    @json_schema = {type: 'array', items: @json_schema } if @is_collection
    @json_schema = {type: 'object', properties: {@root_key.to_sym => @json_schema} } unless @root_key.blank?
    @json_schema
  end
end