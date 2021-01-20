class ReportValidator
  def initialize(report)
    @report = Proxy::ReportDecorator.new(report)
  end

  def validate
    create_errors
  end

  private

  def create_errors
    return if @report.nil?
    return @report.update(validated: true) if route.nil?

    @report.validation_errors.destroy_all
    save_errors_from_request
    response = find_response_with_lowest_errors
    @report.update(route: route, response: response)

    save_errors_from_response(response)
    @report.update(validated: true)
  end

  def route
    return @route if defined? @route
    @route = begin
      route = find_route
      Proxy::RouteDecorator.new(route) if route
    end
  end

  def find_route
    routes = @report.project.build_route_set
    escaped_path = Addressable::URI.parse(@report.url).normalize.to_s
    begin
      main_route = routes.recognize_path(escaped_path, { method: @report.request_method })
    rescue ActionController::RoutingError
      return nil
    end
    Route.find_by(id: main_route[:name])
  end

  def save_errors_from_request
    return if @report.request_body.nil?
    @report.errors_from_request.each do |validation_error|
      validation_error.report = @report
      validation_error.save
    end
  end

  def find_response_with_lowest_errors
    find_response_with_no_errors ||
      find_response_with_no_status_errors ||
      route.responses.first
  end

  def find_response_with_no_errors
    route.responses.detect do |r|
      r.errors_from_report(@report).empty?
    end
  end

  def find_response_with_no_status_errors
    route.responses.detect do |r|
      r.errors_for_status(@report.response_status_code).empty?
    end
  end

  def save_errors_from_response(response)
    return if response.nil?
    response.errors_from_report(@report).each do |validation_error|
      validation_error.report = @report
      validation_error.save
    end
  end
end
