class AttributesController < ApplicationController
  before_action :setup_project_resource_and_attribute, only: [:destroy]

  def destroy
    @attribute.destroy

    redirect_to project_resource_path(@project, @resource)
  end

  def setup_project_resource_and_attribute
    @project = Project.find(params[:project_id])
    @resource = @project.resources.find(params[:resource_id])
    @attribute = @resource.resource_attributes.find(params[:id])
  end
end
