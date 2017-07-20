class ResourcesController < ApplicationController
  layout 'full_width_column'
  before_action :setup_project, only: [:index, :new, :create]
  before_action :setup_project_and_resource, except: [:index, :new, :create]

  def index
    @resources = @project.resources.sort_by { |resource| resource.name.downcase }
  end

  def show
  end

  def new
    @resource = @project.resources.build
    setup_selectable_resources(@project, @resource)
  end

  def edit
    @selectable_resources = @project.resources.to_a
  end

  def create
    @resource = @project.resources.build(resource_params)
    if @resource.save
      redirect_to project_resource_path(@project, @resource)
    else
      setup_selectable_resources(@project, @resource)
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @resource.update(resource_params)
      redirect_to project_resource_path(@project, @resource)
    else
      @selectable_resources = @project.resources.to_a
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @resource.destroy
      redirect_to project_resources_path(@project)
    rescue ActiveRecord::InvalidForeignKey
      flash.now[:error] = t('activerecord.errors.models.resource.attributes.base.destroy_failed_foreign_key')
      render 'show', status: :conflict
    end
  end

  private

  def setup_project
    @project = Project.find(params[:project_id])
  end

  def setup_project_and_resource
    setup_project
    @resource = @project.resources.find(params[:id])
  end

  def setup_selectable_resources(project, resource)
    @selectable_resources = project.resources.to_a
    @selectable_resources = @selectable_resources - [resource]
  end

  def resource_params
    params.require(:resource).permit(:name, :description,
      resource_attributes_attributes: [:id, :name, :description, :primitive_type, :resource_id, :is_array, :enum, :example,
        :pattern, :min_length, :max_length, :minimum, :maximum, :nullable, :_destroy],
      routes_attributes: [:id, :name, :description, :http_method, :url, :_destroy])
  end
end