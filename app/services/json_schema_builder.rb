class JSONSchemaBuilder
  def initialize(representation, options = {})
    @representation = representation
    @is_collection = options[:is_collection]
    @root_key = options[:root_key]
  end

  def execute
    JSONSchemaWrapper.new(@representation.json_schema, @root_key, @is_collection).execute
  end
end
