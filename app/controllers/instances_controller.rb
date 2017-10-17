class InstancesController < AuthenticatedController

  def create
    render json: GenerateJsonInstanceService.new(params[:schema]).execute
  end
end
