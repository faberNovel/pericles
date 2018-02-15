class GenerateJsonInstanceService

  def initialize(schema)
    @schema = schema.is_a?(String) ? JSON.parse(schema) : schema
  end

  def execute
    return '' if @schema.nil?

    js_file = File.join(Rails.root, 'lib', 'node', 'generate_mock.js')
    JSON.parse(Cocaine::CommandLine.new("node", ":js :schema").run(js: js_file, schema: @schema.to_json))
  end
end
