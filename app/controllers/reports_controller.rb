class ReportsController < ApplicationController
  layout 'full_width_column'
  decorates_assigned :report

  def index
    @project = project
    @reports = @project.reports.order(created_at: :desc).page params[:page]
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
