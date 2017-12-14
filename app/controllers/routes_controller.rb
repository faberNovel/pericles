class RoutesController < AuthenticatedController
  before_action :setup_project
  before_action :setup_route, except: [:index, :new, :create]

  def index
    @routes_by_resource = @project.routes.includes(:resource, :resource_representations, :responses)
      .group_by(&:resource)
    @resources = @routes_by_resource.keys.sort_by {|r| r.name.downcase}
    render layout: 'full_width_column'
  end

  def show
    render layout: 'generic'
  end

  def new
    @route = @project.routes.build
    render layout: 'generic'
  end

  def edit
    render layout: 'generic'
  end

  def create
    @route = Route.new(route_params)
    @route.request_headers.build(name: 'Authorization')
    @route.request_headers.build(name: 'Content-Type', value: 'application/json')
    if @route.save
      redirect_to project_route_path(@project, @route)
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def update
    if @route.update(route_params)
      redirect_to project_route_path(@project, @route)
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def destroy
    resource = @route.resource
    @route.destroy

    redirect_to project_resource_path(@project, resource)
  end

  private

  def setup_project
    @project = Project.find(params[:project_id])
  end

  def setup_route
    @route = Route.find(params[:id])
    @responses = @route.responses.order(:status_code)
  end

  def route_params
    params.require(:route).permit(
      :description,
      :http_method,
      :url,
      :resource_id,
      :request_resource_representation_id,
      :request_is_collection,
      :request_root_key,
      request_query_parameters_attributes: [:id, :name, :description, :primitive_type, :is_optional, :_destroy],
      request_headers_attributes: [:id, :name, :value, :_destroy]
    )
  end
end
