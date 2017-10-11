FORBIDDEN_HEADERS = ['Transfer-Encoding'].freeze

class ProxyController < ApplicationController

  def compute_request
    @project = Project.find(params[:project_id])

    proxy_response = MakeRequestToServerService.new(@project.server_url, request).execute
    report = create_report(proxy_response)
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

  def route
    @route ||= find_route
  end

  def path
    request.path[/proxy(\/.+)/, 1]
  end

  def find_route
    routes = @project.build_route_set
    begin
      main_route = routes.recognize_path(path, { method: request.method })
    rescue ActionController::RoutingError
      return nil
    end
    Route.find_by_id(main_route[:name])
  end

  def create_report(proxy_response)
    return unless route

    report = Report.create!(
      route: route,
      url: path,
      status_code: proxy_response.status.code,
      headers: proxy_response.headers.to_h,
      body: proxy_response.body,
    )
    create_errors(proxy_response, report)

    report
  end

  def add_validation_header(report)
    response.set_header('X-Pericles-Report', report.id) if report&.errors?
  end

  def create_errors(proxy_response, report)
    return if report.nil?

    response = find_response_with_lowest_errors(proxy_response)
    save_errors_from_response(proxy_response, response, report)
  end

  def find_response_with_lowest_errors(proxy_response)
    find_response_with_no_errors(proxy_response) ||
    find_response_with_no_status_errors(proxy_response) ||
    route.responses.first
  end

  def find_response_with_no_errors(proxy_response)
    route.responses.detect do |r|
      r.errors_from_http_response(proxy_response).empty?
    end
  end

  def find_response_with_no_status_errors(proxy_response)
    route.responses.detect do |r|
      r.errors_for_status(proxy_response).empty?
    end
  end

  def save_errors_from_response(proxy_response, response, report)
    return if response.nil?

    response.errors_from_http_response(proxy_response).each do |e|
      e.report = report
      e.save
    end
  end
end
