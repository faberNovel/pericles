class ResourcesController < ApplicationController
  layout 'show_project'
  before_action :setup_project, only: :index

  def index
    @resources = @project.resources
  end

  private

  def setup_project
    @project = Project.includes(:resources).find(params[:project_id])
  end
end