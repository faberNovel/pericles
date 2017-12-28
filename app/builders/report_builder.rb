class ReportBuilder
  def initialize(project, http_response, request)
    @project = project
    @http_response = HTTP::ResponseDecorator.new(http_response)
    @request = request
  end

  def build
    human_readable_url = @request.params[:path] || '/'
    report = Report.create(
      project: @project,
      route: route,
      url: human_readable_url,
      response_status_code: @http_response.status.code,
      response_headers: @http_response.headers.to_h,
      response_body: @http_response.body,
      request_body: @request.body.read,
      request_headers: request_headers,
      request_method: @request.method.upcase
    )
    create_errors(report)

    report
  end

  private

  def route
    @route ||= find_route
  end

  def find_route
    routes = @project.build_route_set
    escaped_url =  @request.path[/proxy(\/?.*)/, 1]
    begin
      main_route = routes.recognize_path(escaped_url, { method: @request.method })
    rescue ActionController::RoutingError
      return nil
    end
    Route.find_by_id(main_route[:name])
  end

  def request_headers
    MakeRequestToServerService.new(
      @project.proxy_url, @request
    ).headers
  end

  def create_errors(report)
    return if report.nil? || route.nil?

    response = find_response_with_lowest_errors
    report.update(response: response)

    save_errors_from_response(response, report)
  end

  def find_response_with_lowest_errors
    find_response_with_no_errors ||
    find_response_with_no_status_errors ||
    route.responses.first
  end

  def find_response_with_no_errors
    route.responses.detect do |r|
      r.errors_from_http_response(@http_response).empty?
    end
  end

  def find_response_with_no_status_errors
    route.responses.detect do |r|
      r.errors_for_status(@http_response).empty?
    end
  end

  def save_errors_from_response(response, report)
    return if response.nil?

    response.errors_from_http_response(@http_response).each do |e|
      e.report = report
      e.save
    end
  end
end