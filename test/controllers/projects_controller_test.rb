require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest

	setup do
		Project.delete_all
		@project = create(:project)
	end

	test "should get index" do
		get projects_path
		assert_response :success
	end

	test "should show project" do
		get project_url(@project)
		assert_response :success
	end

	test "should get new" do
		get new_project_path
		assert_response :success
	end

	test "should create project" do
		assert_difference('Project.count') do
      post projects_url, params: { project: { description: 'My description', title: 'My Project' }}
		end
    assert_redirected_to project_url(Project.last)
	end

	test "should not create project" do
		assert_no_difference('Project.count') do
      post projects_url, params: { project: { description: 'My description', title: nil }}
		end
    assert_response :success
	end

end
