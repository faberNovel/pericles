require 'test_helper'

class ReportsControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:full_project)
    @report = create(:report, route: @project.routes.first, project: @project)
  end

  test 'should get index' do
    get project_reports_path(@project)
    assert_response :success
  end

  test 'should get show' do
    get project_report_path(@project, @report)
    assert_response :success
  end

  test 'should revalidate report' do
    post revalidate_project_report_path(@project, @report)
    assert_redirected_to project_report_path(@project, @report)
  end

  test 'should delete validation errors before saving new ones' do
    assert_changes '@report.validation_errors.count' do
      post revalidate_project_report_path(@project, @report)
    end
    assert_no_changes '@report.validation_errors.count' do
      post revalidate_project_report_path(@project, @report)
    end
  end

  test 'member external user should access project reports' do
    external_user = create(:user, :external)
    create(:member, project: @project, user: external_user)
    sign_in external_user

    get project_reports_path(@project)
    assert_response :success

    get project_report_path(@project, @report)
    assert_response :success
  end

  test 'non member external user should not access project reports' do
    external_user = create(:user, :external)
    sign_in external_user

    get project_reports_path(@project)
    assert_response :forbidden

    get project_report_path(@project, @report)
    assert_response :forbidden
  end

  test 'non member external user should access public project reports with read-only permission' do
    external_user = create(:user, :external)
    @project.update(is_public: true)
    sign_in external_user

    get project_reports_path(@project)
    assert_response :success

    get project_report_path(@project, @report)
    assert_response :success
  end

  test 'unauthenticated user should access public project reports with read-only permission' do
    @project.update(is_public: true)
    sign_out :user

    get project_reports_path(@project)
    assert_response :success

    get project_report_path(@project, @report)
    assert_response :success
  end
end
