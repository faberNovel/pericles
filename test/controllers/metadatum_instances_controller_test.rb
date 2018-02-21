require 'test_helper'

class MetadatumInstancesControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @metadatum = create(:metadatum, project: @project)
    @metadatum_instance = create(:metadatum_instance, metadatum: @metadatum)
  end

  test 'should get edit' do
    get edit_metadatum_instance_path(@metadatum_instance)
    assert_response :success
  end

  test 'should update metadatum_instance' do
    assert_not_equal @metadatum_instance.name, 'new name'

    patch metadatum_instance_path(@metadatum_instance), params: {
      metadatum_instance: { name: 'new name' }
    }
    assert_redirected_to project_metadatum_path(@project, @metadatum)
    assert_equal @metadatum_instance.reload.name, 'new name'
  end

  test 'should get new' do
    get new_metadatum_metadatum_instance_path(@metadatum)
    assert_response :success
  end

  test 'should create metadatum_instance' do
    assert_difference 'MetadatumInstance.where(metadatum: @metadatum).count' do
      post metadatum_metadatum_instances_path(@metadatum), params: {
        metadatum_instance: @metadatum_instance.attributes
      }
    end
    assert_redirected_to project_metadatum_path(@project, @metadatum)
  end

  test 'should delete metadatum_instance' do
    assert_difference('MetadatumInstance.where(metadatum: @metadatum).count', -1) do
      delete metadatum_instance_path(@metadatum_instance)
    end
    assert_redirected_to project_metadatum_path(@project, @metadatum)
  end

  test 'member external user should access project resource instances' do
    external_user = create(:user, :external)
    sign_in external_user

    create(:member, project: @project, user: external_user)

    get new_metadatum_metadatum_instance_path(@metadatum)
    assert_response :success

    get edit_metadatum_instance_path(@metadatum_instance)
    assert_response :success

    patch metadatum_instance_path(@metadatum_instance), params: {
      metadatum_instance: { name: 'new name' }
    }
    assert_redirected_to project_metadatum_path(@project, @metadatum)

    post metadatum_metadatum_instances_path(@metadatum), params: {
      metadatum_instance: @metadatum_instance.attributes
    }
    assert_redirected_to project_metadatum_path(@project, @metadatum)

    delete metadatum_instance_path(@metadatum_instance)
    assert_redirected_to project_metadatum_path(@project, @metadatum)
  end

  test 'non member external user should not access project metadatum instances' do
    external_user = create(:user, :external)
    sign_in external_user

    get new_metadatum_metadatum_instance_path(@metadatum)
    assert_response :forbidden

    get edit_metadatum_instance_path(@metadatum_instance)
    assert_response :forbidden

    patch metadatum_instance_path(@metadatum_instance), params: {
      metadatum_instance: { name: 'new name' }
    }
    assert_response :forbidden

    post metadatum_metadatum_instances_path(@metadatum), params: {
      metadatum_instance: @metadatum_instance.attributes
    }
    assert_response :forbidden

    delete metadatum_instance_path(@metadatum_instance)
    assert_response :forbidden
  end

  test 'non member external user should access public project metadatum instances with read-only permission' do
    external_user = create(:user, :external)
    @project.update(is_public: true)
    sign_in external_user

    get new_metadatum_metadatum_instance_path(@metadatum)
    assert_response :forbidden

    get edit_metadatum_instance_path(@metadatum_instance)
    assert_response :forbidden

    patch metadatum_instance_path(@metadatum_instance), params: {
      metadatum_instance: { name: 'new name' }
    }
    assert_response :forbidden

    post metadatum_metadatum_instances_path(@metadatum), params: {
      metadatum_instance: @metadatum_instance.attributes
    }
    assert_response :forbidden

    delete metadatum_instance_path(@metadatum_instance)
    assert_response :forbidden
  end

  test 'unauthenticated user should access public project metadatum instances with read-only permission' do
    @project.update(is_public: true)
    sign_out :user

    get new_metadatum_metadatum_instance_path(@metadatum)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get edit_metadatum_instance_path(@metadatum_instance)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    patch metadatum_instance_path(@metadatum_instance), params: {
      metadatum_instance: { name: 'new name' }
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    post metadatum_metadatum_instances_path(@metadatum), params: {
      metadatum_instance: @metadatum_instance.attributes
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    delete metadatum_instance_path(@metadatum_instance)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end
end
