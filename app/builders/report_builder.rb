class ReportBuilder
  def initialize(project, http_response, request)
    @project = project
    @http_response = HTTP::ResponseDecorator.new(http_response)
    @request = request
  end

  def build
    human_readable_url = @request.params[:path] || '/'
    Report.create(
      project: @project,
      url: human_readable_url,
      response_status_code: @http_response.status.code,
      response_headers: @http_response.headers.to_h,
      response_body: hide_sensitive_value(@http_response.body.to_s.encode('utf-8', invalid: :replace, undef: :replace)),
      request_body: hide_sensitive_value(@request.body.read),
      request_headers: request_headers,
      request_method: @request.method.upcase,
      validated: false
    )
  end

  private

  def request_headers
    MakeRequestToServerService.new(
      @project.proxy_configuration, @request
    ).headers
  end

  def hide_sensitive_value(body)
    begin
      json = JSON.parse(body)
    rescue JSON::ParserError
      return body
    end

    hide_sensitive_value_from_json(json)
  end

  def hide_sensitive_value_from_json(json)
    if json.is_a? Array
      json.map { |hash| hide_sensitive_value(hash) }
    else
      hide_sensitive_value_from_hash(json)
    end.to_json
  end

  def hide_sensitive_value_from_hash(hash)
    return hash unless hash.is_a? Hash

    filters = @request.env['action_dispatch.parameter_filter']
    parameter_filter = ActionDispatch::Http::ParameterFilter.new(filters)
    parameter_filter.filter(hash)
  end
end
