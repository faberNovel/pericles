class ResourcesController < ApplicationController
  layout 'show_project'
  before_action :setup_project, only: [:index, :new, :create]
  before_action :setup_project_and_resource, only: [:show]

  def index
    @resources = @project.resources
  end

  def show
  end

  def new
    @resource = @project.resources.build
    setup_selectable_resources(@project, @resource)
  end

  def create
    @resource = @project.resources.build(resource_params)
    if @resource.save
      redirect_to project_resource_path(@project, @resource)
    else
      setup_selectable_resources(@project, @resource)
      render 'new'
    end
  end

  private

  def setup_project
    @project = Project.find(params[:project_id])
  end

  def setup_project_and_resource
    setup_project
    @resource = @project.resources.includes(:resource_attributes, :routes).find(params[:id])
  end

  def setup_selectable_resources(project, resource)
    @selectable_resources = project.resources
    @selectable_resources.delete(resource)
  end

  def resource_params
    params.require(:resource).permit(:name, :description,
      resource_attributes_attributes: [:id, :name, :description, :primitive_type, :resource_id, :is_array, :example, :_destroy],
      routes_attributes: [:id, :name, :description, :http_method, :url, :_destroy])
  end
end