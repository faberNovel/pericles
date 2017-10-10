class ReportsController < ApplicationController
  layout 'full_width_column'

  def index
    @project = project
    @reports = @project.reports
  end

  def show
    @project = project
    @report = @project.reports.find(params[:id])
  end

  private

  def project
    Project.find(params[:project_id])
  end
end
