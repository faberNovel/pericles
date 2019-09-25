require 'test_helper'

class SecuritySchemeControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @security_scheme = create(:security_scheme, project: @project)
  end

  test 'should get index' do
    get project_security_schemes_path(@project)
    assert_response :success
  end

  test 'should get new' do
    get new_project_security_scheme_path(@project)
    assert_response :success
  end

  test 'should create security scheme' do
    assert_difference('SecurityScheme.where(project: @project).count') do
      post project_security_schemes_path(@project), params: {
        security_scheme: build(:security_scheme).attributes
      }
    end
    assert_redirected_to project_security_schemes_path(@project)
  end

  test 'should get edit' do
    get edit_project_security_scheme_path(@project, @security_scheme)
    assert_response :success
  end

  test 'should update security scheme' do
    put project_security_scheme_path(@project, @security_scheme), params: {
      security_scheme: { key: 'New name' }
    }

    assert_redirected_to project_security_schemes_path(@project)
    assert_equal 'New name', @security_scheme.reload.key
  end

  test 'should delete security scheme' do
    assert_difference 'SecurityScheme.count', -1 do
      delete project_security_scheme_path(@project, @security_scheme)
    end
    assert_redirected_to project_security_schemes_path(@project)
  end

  test 'non member external user should not access project security scheme' do
    external_user = create(:user, :external)
    sign_in external_user

    get project_security_schemes_path(@project)
    assert_response :forbidden

    get new_project_security_scheme_path(@project)
    assert_response :forbidden

    post project_security_schemes_path(@project), params: {
      security_scheme: build(:security_scheme).attributes
    }
    assert_response :forbidden

    get edit_project_security_scheme_path(@project, @security_scheme)
    assert_response :forbidden

    put project_security_scheme_path(@project, @security_scheme), params: {
      security_scheme: { key: 'New name' }
    }
    assert_response :forbidden

    delete project_security_scheme_path(@project, @security_scheme)
    assert_response :forbidden
  end

  test 'member external user should access project security scheme' do
    external_user = create(:user, :external)
    create(:member, project: @project, user: external_user)
    sign_in external_user

    get project_security_schemes_path(@project)
    assert_response :success

    get new_project_security_scheme_path(@project)
    assert_response :success

    post project_security_schemes_path(@project), params: {
      security_scheme: build(:security_scheme).attributes
    }
    assert_redirected_to project_security_schemes_path(@project)

    get edit_project_security_scheme_path(@project, @security_scheme)
    assert_response :success

    put project_security_scheme_path(@project, @security_scheme), params: {
      security_scheme: { key: 'New name' }
    }
    assert_redirected_to project_security_schemes_path(@project)

    delete project_security_scheme_path(@project, @security_scheme)
    assert_redirected_to project_security_schemes_path(@project)
  end

  test 'non member external user should access public project security scheme with read-only permission' do
    external_user = create(:user, :external)
    @project.update(is_public: true)
    sign_in external_user

    get project_security_schemes_path(@project)
    assert_response :success

    get new_project_security_scheme_path(@project)
    assert_response :forbidden

    post project_security_schemes_path(@project), params: {
      security_scheme: build(:security_scheme).attributes
    }
    assert_response :forbidden

    get edit_project_security_scheme_path(@project, @security_scheme)
    assert_response :forbidden

    put project_security_scheme_path(@project, @security_scheme), params: {
      security_scheme: { key: 'New name' }
    }
    assert_response :forbidden

    delete project_security_scheme_path(@project, @security_scheme)
    assert_response :forbidden
  end

  test 'unauthenticated user should access public project security scheme with read-only permission' do
    @project.update(is_public: true)
    sign_out :user

    get project_security_schemes_path(@project)
    assert_response :success

    get new_project_security_scheme_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    post project_security_schemes_path(@project), params: {
      security_scheme: build(:security_scheme).attributes
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get edit_project_security_scheme_path(@project, @security_scheme)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    put project_security_scheme_path(@project, @security_scheme), params: {
      security_scheme: { key: 'New name' }
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    delete project_security_scheme_path(@project, @security_scheme)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should not access non-public project security scheme' do
    sign_out :user

    get project_security_schemes_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get new_project_security_scheme_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    post project_security_schemes_path(@project), params: {
      security_scheme: build(:security_scheme).attributes
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get edit_project_security_scheme_path(@project, @security_scheme)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    put project_security_scheme_path(@project, @security_scheme), params: {
      security_scheme: { key: 'New name' }
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    delete project_security_scheme_path(@project, @security_scheme)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end
end
