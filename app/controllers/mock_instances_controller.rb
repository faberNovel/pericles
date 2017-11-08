class MockInstancesController < AuthenticatedController
  before_action :setup_response_and_project, only: [:new, :create]
  before_action :setup_mock_instance, only: [:edit, :update, :destroy]

  def new
    default_body = GenerateJsonInstanceService.new(@response.json_schema).execute
    @mock_instance = MockInstance.new(response: @response, body: default_body)
  end

  def create
    @mock_instance = @response.mock_instances.build(mock_instance_params)
    if @mock_instance.save
      redirect_to_route
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @mock_instance = MockInstance.find(params[:id])
    if @mock_instance.update(mock_instance_params)
      redirect_to_route
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def destroy
    @mock_instance = MockInstance.find(params[:id])
    @mock_instance.destroy
    redirect_to_route
  end

  private

  def setup_mock_instance
    @mock_instance = MockInstance.find(params[:id])
    @response = @mock_instance.response
    @project = @response.route.resource.project
  end

  def setup_response_and_project
    @response = Response.find(params[:response_id])
    @project = @response.route.resource.project
  end

  def redirect_to_route
    redirect_to resource_route_path(@mock_instance.response.route.resource, @mock_instance.response.route)
  end

  def mock_instance_params
    params.require(:mock_instance).permit(
      :name,
      :body,
    )
  end
end
