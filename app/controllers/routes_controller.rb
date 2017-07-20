class RoutesController < ApplicationController
  before_action :setup_project_and_resource, except: [:index]
  before_action :setup_route, except: [:index, :new, :create]

  def show
    @default_json_instance = "{}"
    render layout: 'generic'
  end

  def new
    @route = @resource.routes.build
    render layout: 'generic'
  end

  def edit
    render layout: 'generic'
  end

  def create
    @route = @resource.routes.build(route_params)
    if @route.save
      redirect_to resource_route_path(@resource, @route)
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def update
    if @route.update(route_params)
      redirect_to resource_route_path(@resource, @route)
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
    @resource = Resource.find(params[:resource_id])
    @project = @resource.project
  end

  def setup_route
    @route = Route.find(params[:id])
  end

  def route_params
    params.require(:route).permit(:name, :description, :http_method, :url, :request_body_schema, :request_resource_representation_id,
      request_query_parameters_attributes: [:id, :name, :description, :primitive_type, :is_optional, :_destroy],
      request_headers_attributes: [:id, :name, :description, :_destroy],
      responses_attributes: [:id, :status_code, :description, :body_schema, :resource_representation_id, :_destroy,
        headers_attributes: [:id, :name, :description, :_destroy]])
  end
end
