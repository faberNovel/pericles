FORBIDDEN_HEADERS = ['Transfer-Encoding'].freeze

class ProxyController < ApplicationController

  def compute_request
    @project = Project.find(params[:project_id])

    proxy_response = MakeRequestToServerService.new(@project.server_url, request).execute
    validate(proxy_response)

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
    route = find_route(proxy_response)
    return unless route

    is_valid = route.responses.any? do |response|
      validate_response_status(response, proxy_response) &&
      validate_response_headers(response, proxy_response) &&
      validate_response_body(response, proxy_response)
    end

    response.set_header('X-Pericles-Report', 'ERROR') unless is_valid
  end

  def find_route(proxy_response)
    path = proxy_response.uri.path
    # FIXME Clément Villain 3/09/17: fix r.url = /users/:id
    @project.routes.detect { |r| r.url == path && request.method == r.http_method }
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
end
