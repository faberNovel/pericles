class ProxyController < ApplicationController

  def compute_request
    project = Project.find(params[:project_id])

    proxy_response = MakeRequestToServerService.new(project.server_url, request).execute

    set_headers(proxy_response.headers.to_h)
    render body: proxy_response.body, status: proxy_response.status.code
  end

  def set_headers(headers)
    headers.each_pair do |key, value|
      response.set_header(key, value)
    end
  end
end
