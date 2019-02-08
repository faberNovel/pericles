class JSONSchemaBuilder
  def initialize(object, options = {})
    @object = object
    @is_collection = options[:is_collection]
    @root_key = options[:root_key]
    @metadata_responses = options[:metadata_responses] || []
  end

  def execute
    return if @object.nil?

    JSONSchemaWrapper.new(
      @object.json_schema, @root_key, @is_collection, @metadata_responses
    ).execute
  end
end
