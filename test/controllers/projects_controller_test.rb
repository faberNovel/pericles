require 'test_helper'

class ProjectsControllerTest < ControllerWithAuthenticationTest

  setup do
    Project.delete_all
    @project = create(:project)
  end

  test "should get index" do
    get projects_path
    assert_response :success
  end

  test "should show project" do
    get project_path(@project)
    assert_response :success
  end

  test "should not show project (not authenticated)" do
    sign_out :user
    get project_path(@project)
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    get new_project_path
    assert_response :success
  end

  test "should not get new (not authenticated)" do
    sign_out :user
    get new_project_path
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    get edit_project_path(@project)
    assert_response :success
  end

  test "should not get edit (not authenticated)" do
    sign_out :user
    get edit_project_path(@project)
    assert_redirected_to new_user_session_path
  end

  test "should create project" do
    assert_difference('Project.count') do
      post projects_path, params: { project: { description: 'My description', title: 'My Project' }}
    end
    assert_redirected_to project_path(Project.last)
  end

  test "should not create project" do
    assert_no_difference('Project.count') do
      post projects_path, params: { project: { description: 'My description', title: nil }}
    end
    assert_response :unprocessable_entity
  end

  test "should not create project (not authenticated)" do
    sign_out :user
    assert_no_difference('Project.count') do
      post projects_path, params: { project: { description: 'My description', title: 'My Project' }}
    end
    assert_redirected_to new_user_session_path
  end

  test "should update project" do
    put project_path(@project), params: { project: { description: 'New Description' }}
    assert_redirected_to project_path(@project)
    @project.reload
    assert_equal 'New Description', @project.description
  end

  test "update project proxy configuration" do
    put project_path(@project), params: {
      project: {
        proxy_configuration_attributes: {
          target_base_url: 'https://api.com'
        }
      }
    }

    assert_equal 'https://api.com', @project.reload.proxy_configuration.target_base_url
  end

  test "update project delete proxy configuration if no target_base_url" do
    @project.create_proxy_configuration(target_base_url: 'https://api.com')

    assert_difference 'ProxyConfiguration.count', -1 do
      put project_path(@project), params: {
        project: {
          proxy_configuration_attributes: {
            target_base_url: ''
          }
        }
      }
    end
  end

  test "should not update project" do
    project_title = @project.title
    put project_path(@project), params: { project: { description: "That's it !", title: "" }}
    assert_response :unprocessable_entity
    @project.reload
    assert_equal project_title, @project.title
  end

  test "should not update project (not authenticated)" do
    sign_out :user
    project_original_title = @project.title
    put project_path(@project), params: { project: { title: "New title" }}
    @project.reload
    assert_equal project_original_title, @project.title
    assert_redirected_to new_user_session_path
  end

  test "should delete project" do
    assert_difference 'Project.count', -1 do
      delete project_path(@project)
    end
    assert_redirected_to projects_path
  end

  test "should not delete project (not authenticated)" do
    sign_out :user
    assert_no_difference 'Project.count' do
      delete project_path(@project)
    end
    assert_redirected_to new_user_session_path
  end

  test "should get zip file with all json schemas" do
    project = create(:full_project)
    get project_path(project, format: 'json_schema')
    assert_response :success
    assert_equal response.headers['Content-Type'], 'application/zip'
  end

  test "should get all swift files" do
    project = create(:full_project)
    get project_path(project, format: 'swift')
    assert_response :success
    assert_equal response.headers['Content-Type'], 'application/zip'
  end

  test "should get all java files" do
    project = create(:full_project)
    get project_path(project, format: 'java')
    assert_response :success
    assert_equal response.headers['Content-Type'], 'application/zip'
  end

  test "should get all kotlin files" do
    project = create(:full_project)
    get project_path(project, format: 'kotlin')
    assert_response :success
    assert_equal response.headers['Content-Type'], 'application/zip'
  end

  test 'external user should not show project' do
    external_user = create(:user, :external)
    sign_in external_user

    get project_path(@project)
    assert_response :forbidden
  end

  test 'external user should not create' do
    external_user = create(:user, :external)
    sign_in external_user

    post projects_path, params: { project: { description: 'My description', title: 'My Project' }}
    assert_response :forbidden
  end

  test 'external user can see public project' do
    external_user = create(:user, :external)
    sign_in external_user
    @project.update(is_public: true)

    get project_path(@project)
    assert_response :success
  end
end
