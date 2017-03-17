class RoutesController < ApplicationController
  before_action :setup_project_resource_and_route

  def show
    render layout: 'generic'
  end

  def edit
    render layout: 'full_width_column'
  end

  def setup_project_resource_and_route
    @project = Project.find(params[:project_id])
    @resource = @project.resources.find(params[:resource_id])
    @route = @resource.routes.find(params[:id])
  end
end
