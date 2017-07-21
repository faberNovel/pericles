class ProxyController < ApplicationController

  def compute_request
    project = Project.find(params[:project_id])
    response = MakeRequestToServerService.new(project.server_url, request).execute
    render json: response.body, status: response.code, headers: response.headers
  end

end
