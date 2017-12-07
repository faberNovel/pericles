class ResponsesController < AuthenticatedController
  layout 'generic'
  before_action :setup_route_resource_and_project, only: [:new, :create]
  before_action :setup_route_resource_project_and_response, except: [:new, :create]

  def new
    @response = @route.responses.build
  end

  def edit
  end

  def create
    @response = @route.responses.build(response_params)
    if @response.save
      redirect_to resource_route_path(@resource, @route)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @response.update(response_params)
      redirect_to resource_route_path(@resource, @route)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @response.destroy

    redirect_to resource_route_path(@resource, @route)
  end

  private

  def setup_route_resource_and_project
    @route = Route.find(params[:route_id])
    @resource = @route.resource
    @project = @resource.project
  end

  def setup_route_resource_project_and_response
    setup_route_resource_and_project
    @response = @route.responses.find(params[:id])
  end

  def response_params
    params.require(:response).permit(
      :status_code,
      :resource_representation_id,
      :api_error_id,
      :is_collection,
      :root_key,
      headers_attributes: [:id, :name, :_destroy]
    )
  end
end
