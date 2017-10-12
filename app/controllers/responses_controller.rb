class ResponsesController < AuthenticatedController
  layout 'generic'
  before_action :setup_route_resource_project_and_response

  def edit
  end

  def update
    if @response.update(response_params)
      redirect_to resource_route_path(@resource, @route)
    else
      render 'edit', status: :unprocessable_entity
    end
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
    params.require(:response).permit(:status_code, :description, :body_schema, :resource_representation_id, :is_collection,
     :root_key, headers_attributes: [:id, :name, :description, :_destroy])
  end
end
