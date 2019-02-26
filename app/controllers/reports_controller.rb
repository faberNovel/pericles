class ReportsController < ApplicationController
  include ProjectRelated

  decorates_assigned :reports
  decorates_assigned :report

  def index
    @q = project.reports.ransack(params[:q])
    @reports = @q.result.order(created_at: :desc).page(params[:page]).preload(:route, :response)
  end

  def show
    @report = project.reports.find(params[:id])
  end
end
