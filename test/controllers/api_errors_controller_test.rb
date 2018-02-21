require 'test_helper'

class ApiErrorControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @api_error = create(:api_error, project: @project)
  end

  test 'should get index' do
    get project_api_errors_path(@project)
    assert_response :success
  end

  test 'should get show' do
    get project_api_error_path(@project, @api_error)
    assert_response :success
  end

  test 'should get show json_schema' do
    get project_api_error_path(@project, @api_error, format: :json_schema), params: {
      is_collection: true, root_key: ''
    }

    assert_response :success
    assert_equal JSON.parse(response.body)['type'], 'array'

    get project_api_error_path(@project, @api_error, format: :json_schema), params: {
      is_collection: false, root_key: 'root_key'
    }
    assert_equal JSON.parse(response.body)['type'], 'object'
    assert_equal JSON.parse(response.body)['required'], ['root_key']
  end

  test 'should get edit' do
    get edit_project_api_error_path(@project, @api_error)
    assert_response :success
  end

  test 'should update api_error' do
    assert_not_equal 'new name', @api_error.name
    put project_api_error_path(@project, @api_error), params: {
      api_error: {
        name: 'new name'
      }
    }
    assert_equal 'new name', @api_error.reload.name
    assert_redirected_to project_api_error_path(@project, @api_error)
  end

  test 'should get new' do
    get new_project_api_error_path(@project)
    assert_response :success
  end

  test 'should create new api_error' do
    assert_difference 'ApiError.where(project: @project).count' do
      post project_api_errors_path(@project), params: {
        api_error: build(:api_error).attributes
      }
    end
    assert_redirected_to project_api_error_path(@project, ApiError.order(:created_at).last)
  end

  test 'unauthenticated user should not get index' do
    sign_out :user
    get project_api_errors_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should not get show' do
    sign_out :user
    get project_api_error_path(@project, @api_error)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should not get edit' do
    sign_out :user
    get edit_project_api_error_path(@project, @api_error)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should not update api_error' do
    sign_out :user
    assert_not_equal 'new name', @api_error.name
    put project_api_error_path(@project, @api_error), params: {
      api_error: {
        name: 'new name'
      }
    }
    assert_not_equal 'new name', @api_error.reload.name
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should not get new' do
    sign_out :user
    get new_project_api_error_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should not create new api_error' do
    sign_out :user
    assert_no_difference 'ApiError.where(project: @project).count' do
      post project_api_errors_path(@project), params: {
        api_error: build(:api_error).attributes
      }
    end
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should get index of public project' do
    sign_out :user
    @project.update(is_public: true)

    get project_api_errors_path(@project)
    assert_response :success
  end

  test 'unauthenticated user should get show of public project' do
    sign_out :user
    @project.update(is_public: true)

    get project_api_error_path(@project, @api_error)
    assert_response :success
  end

  test 'unauthenticated user should not get edit of public project' do
    sign_out :user
    @project.update(is_public: true)

    get edit_project_api_error_path(@project, @api_error)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should not update api_error of public project' do
    sign_out :user
    @project.update(is_public: true)

    assert_not_equal 'new name', @api_error.name
    put project_api_error_path(@project, @api_error), params: {
      api_error: {
        name: 'new name'
      }
    }
    assert_not_equal 'new name', @api_error.reload.name
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should not get new of public project' do
    sign_out :user
    @project.update(is_public: true)

    get new_project_api_error_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'unauthenticated user should not create new api_error of public project' do
    sign_out :user
    @project.update(is_public: true)

    assert_no_difference 'ApiError.where(project: @project).count' do
      post project_api_errors_path(@project), params: {
        api_error: build(:api_error).attributes
      }
    end
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'non member external user should not get index' do
    sign_in create(:user, :external)

    get project_api_errors_path(@project)
    assert_response :forbidden
  end

  test 'non member external user should not get show' do
    sign_in create(:user, :external)

    get project_api_error_path(@project, @api_error)
    assert_response :forbidden
  end

  test 'non member external user should not get edit' do
    sign_in create(:user, :external)

    get edit_project_api_error_path(@project, @api_error)
    assert_response :forbidden
  end

  test 'non member external user should not update api_error' do
    sign_in create(:user, :external)

    assert_not_equal 'new name', @api_error.name
    put project_api_error_path(@project, @api_error), params: {
      api_error: {
        name: 'new name'
      }
    }
    assert_not_equal 'new name', @api_error.reload.name
    assert_response :forbidden
  end

  test 'non member external user should not get new' do
    sign_in create(:user, :external)

    get new_project_api_error_path(@project)
    assert_response :forbidden
  end

  test 'non member external user should not create new api_error' do
    sign_in create(:user, :external)

    assert_no_difference 'ApiError.where(project: @project).count' do
      post project_api_errors_path(@project), params: {
        api_error: build(:api_error).attributes
      }
    end
    assert_response :forbidden
  end

  test 'member external user should get index' do
    user = create(:user, :external)
    create(:member, project: @project, user: user)
    sign_in user

    get project_api_errors_path(@project)
    assert_response :success
  end

  test 'member external user should get show' do
    user = create(:user, :external)
    create(:member, project: @project, user: user)
    sign_in user

    get project_api_error_path(@project, @api_error)
    assert_response :success
  end

  test 'member external user should get edit' do
    user = create(:user, :external)
    create(:member, project: @project, user: user)
    sign_in user

    get edit_project_api_error_path(@project, @api_error)
    assert_response :success
  end

  test 'member external user should update api_error' do
    user = create(:user, :external)
    create(:member, project: @project, user: user)
    sign_in user

    assert_not_equal 'new name', @api_error.name
    put project_api_error_path(@project, @api_error), params: {
      api_error: {
        name: 'new name'
      }
    }
    assert_equal 'new name', @api_error.reload.name
    assert_redirected_to project_api_error_path(@project, @api_error)
  end

  test 'member external user should get new' do
    user = create(:user, :external)
    create(:member, project: @project, user: user)
    sign_in user

    get new_project_api_error_path(@project)
    assert_response :success
  end

  test 'member external user should create new api_error' do
    user = create(:user, :external)
    create(:member, project: @project, user: user)
    sign_in user

    assert_difference 'ApiError.where(project: @project).count' do
      post project_api_errors_path(@project), params: {
        api_error: build(:api_error).attributes
      }
    end
    assert_redirected_to project_api_error_path(@project, ApiError.order(:created_at).last)
  end
end
