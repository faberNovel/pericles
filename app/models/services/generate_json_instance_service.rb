class GenerateJsonInstanceService
  source = File.open(File.join(Rails.root, 'app', 'assets', 'javascripts', 'json-schema-faker.min.js')).read
  # Avoid reloading the context, we save ~500ms/request
  @@context = ExecJS.compile(source)

  def initialize(schema)
    @schema = schema
  end

  def execute
    @@context.eval("jsf(" + @schema.to_json + ")");
  end
end
