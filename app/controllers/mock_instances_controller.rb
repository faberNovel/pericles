class MockInstancesController < AuthenticatedController
  layout 'full_width_column'
  before_action :setup_resource_and_project, only: [:new, :create]
  before_action :setup_mock_instance, only: [:edit, :update, :destroy]

  def new
    default_body = GenerateJsonInstanceService.new(@resource.json_schema).execute
    @mock_instance = MockInstance.new(resource: @resource, body: default_body)
  end

  def create
    @mock_instance = @resource.mock_instances.build(mock_instance_params)
    if @mock_instance.save
      redirect_to_resource
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @mock_instance = MockInstance.find(params[:id])
    if @mock_instance.update(mock_instance_params)
      redirect_to_resource
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def destroy
    @mock_instance = MockInstance.find(params[:id])
    @mock_instance.destroy
    redirect_to_resource
  end

  private

  def setup_mock_instance
    @mock_instance = MockInstance.find(params[:id])
    @resource = @mock_instance.resource
    @project = @resource.project
  end

  def setup_resource_and_project
    @resource = Resource.find(params[:resource_id])
    @project = @resource.project
  end

  def redirect_to_resource
    redirect_to project_resource_path(@project, @resource)
  end

  def mock_instance_params
    params.require(:mock_instance).permit(
      :name,
      :body,
    )
  end
end
