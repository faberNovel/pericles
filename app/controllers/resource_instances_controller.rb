class ResourceInstancesController < AbstractInstancesController
  def model_name
    'resource'
  end

  def redirect_to_model
    redirect_to project_resource_path(project, model, anchor: 'pills-resource-instances')
  end
end
