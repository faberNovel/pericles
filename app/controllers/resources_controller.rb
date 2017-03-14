class ResourcesController < ApplicationController
  layout 'show_project'
  before_action :setup_project, only: [:index, :new]

  def index
    @resources = @project.resources
  end

  def new
    @resource = @project.resources.build
    @selectable_resources = @project.resources
    @selectable_resources.delete(@resource)
  end

  private

  def setup_project
    @project = Project.includes(:resources).find(params[:project_id])
  end
end