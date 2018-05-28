require 'zip'

class JSONSchemaZipBuilder < AbstractZipBuilder
  def initialize(project)
    @project = project
  end

  def collection
    @project.resources.map(&:responses).flatten.select(&:resource_representation)
  end

  def filename(response)
    folder_name = response.route.resource.name.downcase.parameterize(separator: '_')

    verb = response.route.http_method.to_s
    route = response.route.url.delete(':')
    representation = response.resource_representation.name
    status_code = response.status_code
    file = "#{verb}_#{route}_#{representation}_#{status_code}".parameterize(separator: '_') + '.json_schema'

    "#{folder_name}/#{file}"
  end

  def file_content(response)
    JSON.stable_pretty_generate(response.json_schema)
  end
end
