require 'zip'

class JSONSchemaZipBuilder < AbstractZipBuilder
  def initialize(project)
    @project = project
  end

  def collection
    responses = @project.responses
                  .where.not(resource_representation_id: nil)
                  .includes(:metadata, route: :resource, resource_representation: :attributes_resource_representations)
    routes = @project.routes
                .joins(:request_resource_representation)
                .preload(:resource, request_resource_representation: :attributes_resource_representations)
    responses + routes
  end

  def filename(response_or_route)
    if response_or_route.is_a?(Response)
      response_filename(response_or_route)
    else
      route_filename(response_or_route)
    end
  end

  def file_content(response_or_route)
    if response_or_route.is_a?(Response)
      JSON.stable_pretty_generate(response_or_route.json_schema)
    else
      JSON.stable_pretty_generate(response_or_route.request_json_schema)
    end
  end

  private

  def response_filename(response)
    route = response.route
    folder_name = folder_name(route)

    verb = route.http_method.to_s
    route = route.url.delete(':')
    representation = response.resource_representation.name
    status_code = response.status_code
    file = "#{verb}_#{route}_#{representation}_#{status_code}".parameterize(separator: '_') + '.json_schema'

    "#{folder_name}/#{file}"
  end

  def folder_name(route)
    route.resource.name.downcase.parameterize(separator: '_')
  end

  def route_filename(route)
    request = route.request_resource_representation
    folder_name = folder_name(route)

    verb = route.http_method.to_s
    route = route.url.delete(':')
    file = "request_#{verb}_#{route}_#{request.name}".parameterize(separator: '_') + '.json_schema'

    "#{folder_name}/#{file}"
  end
end
