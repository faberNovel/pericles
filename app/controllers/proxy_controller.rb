FORBIDDEN_HEADERS = ['Transfer-Encoding'].freeze

class ProxyController < ApplicationController

  def compute_request
    @project = Project.find(params[:project_id])
    @request_service = MakeRequestToServerService.new(@project.proxy_url, request)
    proxy_response = @request_service.execute

    if proxy_response.headers['Content-Type'] == 'application/json'
      report = ReportBuilder.new(@project, proxy_response, request).build
      add_validation_header(report)
    end

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

  def add_validation_header(report)
    response.set_header('X-Pericles-Report', report.id.to_s) if report&.errors?
  end
end
