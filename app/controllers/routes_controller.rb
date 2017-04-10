class RoutesController < ApplicationController
  before_action :setup_project_and_resource, only: [:new, :create]
  before_action :setup_project_resource_and_route, except: [:new, :create]

  def show
    @default_json_instance = "{}"
    render layout: 'generic'
  end

  def new
    @route = @resource.routes.build
    render layout: 'full_width_column'
  end

  def edit
    render layout: 'full_width_column'
  end

  def create
    @route = @resource.routes.build(route_params)
    if @route.save
      redirect_to project_resource_route_path(@project, @resource, @route)
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def update
    if @route.update(route_params)
      redirect_to project_resource_route_path(@project, @resource, @route)
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def destroy
    @route.destroy

    redirect_to project_resource_path(@project, @resource)
  end

  private

  def setup_project_and_resource
    @project = Project.find(params[:project_id])
    @resource = @project.resources.find(params[:resource_id])
  end

  def setup_project_resource_and_route
    setup_project_and_resource
    @route = @resource.routes.find(params[:id])
  end

  def route_params
    params.require(:route).permit(:name, :description, :http_method, :url, :request_body_schema, :response_schema,
      request_query_parameters_attributes: [:id, :name, :description, :primitive_type, :is_optional, :_destroy],
      request_headers_attributes: [:id, :name, :description, :_destroy])
  end
end
