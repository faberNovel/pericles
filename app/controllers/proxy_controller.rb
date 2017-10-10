FORBIDDEN_HEADERS = ['Transfer-Encoding'].freeze

class ProxyController < ApplicationController

  def compute_request
    @project = Project.find(params[:project_id])

    proxy_response = MakeRequestToServerService.new(@project.server_url, request).execute
    is_valid = validate(proxy_response)
    report = create_report(proxy_response, is_valid)
    add_validation_header(report)

    set_headers(proxy_response.headers.to_h)
    render body: proxy_response.body, status: proxy_response.status.code
  end

  private

  def set_headers(headers)
    headers.each_pair do |key, value|
      response.set_header(key, value) unless FORBIDDEN_HEADERS.include? key
    end
    response.set_header('Access-Control-Allow-Origin', '*')
  end

  def validate(proxy_response)
    return unless route

    route.responses.any? do |response|
      validate_response_status(response, proxy_response) &&
      validate_response_headers(response, proxy_response) &&
      validate_response_body(response, proxy_response)
    end
  end

  def route
    @route ||= find_route
  end

  def find_route
    path = request.path[/proxy(\/.+)/, 1]
    routes = @project.build_route_set
    begin
      main_route = routes.recognize_path(path, { method: request.method })
    rescue ActionController::RoutingError
      return nil
    end
    Route.find_by_id(main_route[:name])
  end

  def validate_response_headers(response, proxy_response)
    response.headers.all? { |h| proxy_response.headers.to_h.key? h.name }
  end

  def validate_response_status(response, proxy_response)
    response.status_code == proxy_response.status.code
  end

  def validate_response_body(response, proxy_response)
    JSON::Validator.fully_validate(response.body_schema, proxy_response.body, json: true).empty?
  end

  def create_report(proxy_response, is_valid)
    return unless route
    Report.create!(
      route: route,
      status_code: proxy_response.status.code,
      headers: proxy_response.headers.to_h,
      body: proxy_response.body,
      is_valid: is_valid
    )
  end

  def add_validation_header(report)
    response.set_header('X-Pericles-Report', report.id) unless report.nil? || report.is_valid
  end
end
