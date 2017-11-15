class ResourceInstancesController < AuthenticatedController
  layout 'full_width_column'
  before_action :setup_resource_and_project, only: [:new, :create]
  before_action :setup_resource_instance, only: [:edit, :update, :destroy]

  def new
    default_body = GenerateJsonInstanceService.new(@resource.json_schema).execute
    @resource_instance = ResourceInstance.new(resource: @resource, body: default_body)
  end

  def create
    @resource_instance = @resource.resource_instances.build(resource_instance_params)
    if @resource_instance.save
      redirect_to_resource
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @resource_instance = ResourceInstance.find(params[:id])
    if @resource_instance.update(resource_instance_params)
      redirect_to_resource
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def destroy
    @resource_instance = ResourceInstance.find(params[:id])
    @resource_instance.destroy
    redirect_to_resource
  end

  private

  def setup_resource_instance
    @resource_instance = ResourceInstance.find(params[:id])
    @resource = @resource_instance.resource
    @project = @resource.project
  end

  def setup_resource_and_project
    @resource = Resource.find(params[:resource_id])
    @project = @resource.project
  end

  def redirect_to_resource
    redirect_to project_resource_path(@project, @resource)
  end

  def resource_instance_params
    params.require(:resource_instance).permit(
      :name,
      :body,
    )
  end
end
