class ReportsController < ApplicationController
  include ProjectRelated

  layout 'full_width_column'
  decorates_assigned :report

  def index
    @reports = project.reports.order(created_at: :desc).page params[:page]
  end

  def show
    @report = project.reports.find(params[:id])
  end
end
