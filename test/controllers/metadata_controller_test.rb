require 'test_helper'

class MetadataControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @metadatum = create(:metadatum, project: @project)
  end

  test 'should get index' do
    get project_metadata_path(@project)
    assert_response :success
  end

  test 'should get new' do
    get new_project_metadatum_path(@project)
    assert_response :success
  end

  test 'should create metadatum' do
    assert_difference('Metadatum.where(project: @project).count') do
      post project_metadata_path(@project), params: {
        metadatum: build(:metadatum).attributes
      }
    end
    assert_redirected_to project_metadata_path(@project)
  end

  test 'should get edit' do
    get edit_metadatum_path(@metadatum)
    assert_response :success
  end

  test 'should update metadatum' do
    assert_not_equal 'New name', @metadatum

    put metadatum_path(@metadatum), params: {
      metadatum: { name: 'New name' }
    }

    assert_redirected_to project_metadata_path(@project)
    assert_equal 'New name', @metadatum.reload.name
  end

  test 'should delete metadatum' do
    assert_difference 'Metadatum.count', -1 do
      delete metadatum_path(@metadatum)
    end
    assert_redirected_to project_metadata_path(@project)
  end

  test 'non member external user should not access project metadata' do
    external_user = create(:user, :external)
    sign_in external_user

    get project_metadata_path(@project)
    assert_response :forbidden

    get new_project_metadatum_path(@project)
    assert_response :forbidden

    post project_metadata_path(@project), params: {
      metadatum: build(:metadatum).attributes
    }
    assert_response :forbidden

    get edit_metadatum_path(@metadatum)
    assert_response :forbidden

    put metadatum_path(@metadatum), params: {
      metadatum: { name: 'New name' }
    }
    assert_response :forbidden

    delete metadatum_path(@metadatum)
    assert_response :forbidden
  end

  test 'member external user should access project metadata' do
    external_user = create(:user, :external)
    create(:member, project: @project, user: external_user)
    sign_in external_user

    get project_metadata_path(@project)
    assert_response :success

    get new_project_metadatum_path(@project)
    assert_response :success

    post project_metadata_path(@project), params: {
      metadatum: build(:metadatum).attributes
    }
    assert_redirected_to project_metadata_path(@project)

    get edit_metadatum_path(@metadatum)
    assert_response :success

    put metadatum_path(@metadatum), params: {
      metadatum: { name: 'New name' }
    }
    assert_redirected_to project_metadata_path(@project)

    delete metadatum_path(@metadatum)
    assert_redirected_to project_metadata_path(@project)
  end

  test 'non member external user should access public project metadata with read-only permission' do
    external_user = create(:user, :external)
    @project.update(is_public: true)
    sign_in external_user

    get project_metadata_path(@project)
    assert_response :success

    get new_project_metadatum_path(@project)
    assert_response :forbidden

    post project_metadata_path(@project), params: {
      metadatum: build(:metadatum).attributes
    }
    assert_response :forbidden

    get edit_metadatum_path(@metadatum)
    assert_response :forbidden

    put metadatum_path(@metadatum), params: {
      metadatum: { name: 'New name' }
    }
    assert_response :forbidden

    delete metadatum_path(@metadatum)
    assert_response :forbidden
  end

  test 'unauthenticated user should access public project metadata with read-only permission' do
    @project.update(is_public: true)
    sign_out :user

    get project_metadata_path(@project)
    assert_response :success

    get new_project_metadatum_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    post project_metadata_path(@project), params: {
      metadatum: build(:metadatum).attributes
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get edit_metadatum_path(@metadatum)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    put metadatum_path(@metadatum), params: {
      metadatum: { name: 'New name' }
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    delete metadatum_path(@metadatum)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should not access non-public project metadata' do
    sign_out :user

    get project_metadata_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get new_project_metadatum_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    post project_metadata_path(@project), params: {
      metadatum: build(:metadatum).attributes
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get edit_metadatum_path(@metadatum)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    put metadatum_path(@metadatum), params: {
      metadatum: { name: 'New name' }
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    delete metadatum_path(@metadatum)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end
end
