class RoutesController < ApplicationController
  before_action :setup_project_resource_and_route

  def show
    render layout: 'generic'
  end

  def edit
    render layout: 'full_width_column'
  end

  def update
    if @route.update(route_params)
      redirect_to project_resource_route_path(@project, @resource, @route)
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def setup_project_resource_and_route
    @project = Project.find(params[:project_id])
    @resource = @project.resources.find(params[:resource_id])
    @route = @resource.routes.find(params[:id])
  end

  def route_params
    params.require(:route).permit(:name, :description, :http_method, :url, :body_schema, :response_schema)
  end
end
