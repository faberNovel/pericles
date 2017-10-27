require 'test_helper'

class CleanOldReportsTest < ActiveSupport::TestCase
  def setup
    @new_report = create(:report)
    travel_to Date.current - 1.month
    @old_report = create(:report)
    travel_back
    Pericles_GWGw::Application.load_tasks
    Rake::Task['proxy:clean_reports'].execute
  end

  test "new report is not deleted" do
    assert_equal @new_report, Report.find_by(id: @new_report.id)
  end

  test "old report is deleted" do
    assert_nil Report.find_by(id: @old_report.id)
  end
end