class ReportValidatorJob < Struct.new(:report_id)
  def perform
    report = Report.find_by(id: report_id)
    return if report.nil? || report.validated

    ReportValidator.new(report).validate
  end
end
