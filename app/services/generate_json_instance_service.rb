class GenerateJsonInstanceService
  def initialize(schema)
    @schema = schema.is_a?(String) ? JSON.parse(schema) : schema
  end

  def execute
    return '' if @schema.nil?

    js_file = File.join(Rails.root, 'lib', 'node', 'generate_mock.js')
    thread = Thread.new do
      JSON.parse(Terrapin::CommandLine.new('node', ':js :schema').run(js: js_file, schema: @schema.to_json))
    end
    thread.join(5)&.value || { error: 'A loop prevents this json to be generated' }
  end
end
