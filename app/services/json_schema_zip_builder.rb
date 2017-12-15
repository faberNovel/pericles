class JSONSchemaZipBuilder
  def initialize(project)
    @project = project
  end

  def zip_data
    stringio = Zip::OutputStream.write_buffer do |zio|
      @project.resources.each do |resource|
        resource.responses.each do |response|
          next unless response.resource_representation
          folder_name = resource.name.downcase.parameterize(separator: '_')
          zio.put_next_entry("#{folder_name}/#{filename(response)}")
          zio.write JSON.pretty_generate(response.json_schema)
        end
      end
    end
    stringio.rewind
    stringio.sysread
  end

  private

  def filename(response)
    verb = response.route.http_method.to_s
    route = response.route.url.gsub(':', '')
    representation = response.resource_representation.name
    status_code = response.status_code
    "#{verb}_#{route}_#{representation}_#{status_code}".parameterize(separator: '_') + '.json_schema'
  end
end
