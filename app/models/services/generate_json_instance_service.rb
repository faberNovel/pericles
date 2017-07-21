class GenerateJsonInstanceService
  def initialize(schema)
    @schema = schema
  end

  def execute
    source = File.open(File.join(Rails.root, 'app', 'assets', 'javascripts', 'json-schema-faker.min.js')).read
    context = ExecJS.compile(source)
    context.eval("jsf(" + @schema.to_json + ")");
  end
end
