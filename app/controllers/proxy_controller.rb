class ProxyController < ApplicationController

  def compute_request
    project = Project.find(params[:project_id])
    response = MakeRequestToServerService.new(project.server_url, request).execute
    render body: response.body, status: response.status.code, headers: response.headers
  end

end
