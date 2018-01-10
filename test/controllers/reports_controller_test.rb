require 'test_helper'

class ReportsControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:full_project)
    @report = create(:report, route: @project.routes.first, project: @project)
  end

  test "should get index" do
    get project_reports_path(@project)
    assert_response :success
  end

  test "should get show" do
    get project_report_path(@project, @report)
    assert_response :success
  end

  test "user must be logged in to get index" do
    sign_out :user
    get project_reports_path(@project)
    assert_redirected_to new_user_session_path
  end

  test "user must be logged in to get show" do
    sign_out :user
    get project_report_path(@project, @report)
    assert_redirected_to new_user_session_path
  end
end
