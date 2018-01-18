require 'test_helper'

class MetadataControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @metadatum = create(:metadatum, project: @project)
  end

  test "should show index" do
    get project_metadata_path(@project)
    assert_response :success
  end

  test 'non member external user should not access project metadata' do
    external_user = create(:user, :external)
    sign_in external_user

    get project_metadata_path(@project)
    assert_response :forbidden
  end

  test 'member external user should access project metadata' do
    external_user = create(:user, :external)
    create(:member, project: @project, user: external_user)
    sign_in external_user

    get project_metadata_path(@project)
    assert_response :success
  end

  test 'non member external user should access public project metadata with read-only permission' do
    external_user = create(:user, :external)
    @project.update(is_public: true)
    sign_in external_user


    get project_metadata_path(@project)
    assert_response :success
  end

  test 'unauthenticated user should access public project metadata with read-only permission' do
    @project.update(is_public: true)
    sign_out :user

    get project_metadata_path(@project)
    assert_response :success
  end

  test "unauthenticated user should not access non-public project metadata" do
    sign_out :user

    get project_metadata_path(@project)
    assert_redirected_to new_user_session_path
  end
end
