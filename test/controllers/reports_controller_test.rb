require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = create(:full_project)
    @report = create(:report, route: @project.routes.first)
  end

  test "should get index" do
    get project_reports_path(@project)
    assert_response :success
  end

  test "should get show" do
    get project_report_path(@project, @report)
    assert_response :success
  end
end
