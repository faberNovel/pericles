class RoutesController < ApplicationController
  layout 'generic'
  before_action :setup_project_resource_and_route

  def show
  end

  def setup_project_resource_and_route
    @project = Project.find(params[:project_id])
    @resource = @project.resources.find(params[:resource_id])
    @route = @resource.routes.find(params[:id])
  end
end