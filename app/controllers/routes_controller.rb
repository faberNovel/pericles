class RoutesController < ApplicationController
  before_action :setup_project_and_resource, only: [:new]
  before_action :setup_project_resource_and_route, except: [:new]

  def show
    render layout: 'generic'
  end

  def new
    @route = @resource.routes.build
    render layout: 'full_width_column'
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

  def setup_project_and_resource
    @project = Project.find(params[:project_id])
    @resource = @project.resources.find(params[:resource_id])
  end

  def setup_project_resource_and_route
    setup_project_and_resource
    @route = @resource.routes.find(params[:id])
  end

  def route_params
    params.require(:route).permit(:name, :description, :http_method, :url, :body_schema, :response_schema)
  end
end
