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
    hide_password_in_bodies(@report.request_body, @report.response_body)
  end

  def revalidate
    report = project.reports.find(params[:id])
    ReportValidator.new(report).validate
    redirect_to project_report_path(project, report)
  end

  private

  def hide_password_in_bodies(*bodies)
    bodies.each do |body|
      body&.gsub!(/"password"\s*:\s*"[^"]*"/, '"password":"********"')
    end
  end
end
