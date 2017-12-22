require 'test_helper'

class ResourcesControllerTest < ControllerWithAuthenticationTest

  test "should get index with resources sorted in alphabetical order" do
    project = create(:project)
    second_resource = create(:resource, name: "Second", project: project)
    first_resource = create(:resource, name: "First", project: project)
    get project_resources_path(project)
    assert_response :success
    assert assigns[:resources]
    assert_equal [first_resource, second_resource], assigns[:resources]
  end

  test "should not get index (not authenticated)" do
    sign_out :user
    project = create(:project)
    get project_resources_path(project)
    assert_redirected_to new_user_session_path
  end

  test "should show resource" do
    resource = create(:resource_with_attributes)
    get project_resource_path(resource.project, resource)
    assert_response :success
  end

  test "should not show resource (not authenticated)" do
    sign_out :user
    resource = create(:resource_with_attributes)
    get project_resource_path(resource.project, resource)
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    project = create(:project)
    get new_project_resource_path(project)
    assert_response :success
  end

  test "should not get new (not authenticated)" do
    sign_out :user
    project = create(:project)
    get new_project_resource_path(project)
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    resource = create(:resource)
    get edit_project_resource_path(resource.project, resource)
    assert_response :success
  end

  test "should not get edit (not authenticated)" do
    sign_out :user
    resource = create(:resource)
    get edit_project_resource_path(resource.project, resource)
    assert_redirected_to new_user_session_path
  end

  test "should create resource" do
    resource = build(:resource)
    assert_difference('Resource.count') do
      post project_resources_path(resource.project), params: { resource: resource.attributes }
    end
    resource = assigns[:resource]
    assert_not_nil resource, "should create resource"
    assert_redirected_to project_resource_path(resource.project, resource)
  end

  test "should not create resource without a name" do
    resource = build(:resource)
    resource.name = ""
    assert_no_difference('Resource.count') do
      post project_resources_path(resource.project), params: { resource: resource.attributes }
    end
    assert_response :unprocessable_entity
  end

  test "should not create resource (not authenticated)" do
    sign_out :user
    resource = build(:resource)
    assert_no_difference('Resource.count') do
      post project_resources_path(resource.project), params: { resource: resource.attributes }
    end
    assert_redirected_to new_user_session_path
  end

  test "should update resource" do
    resource = create(:resource)
    put project_resource_path(resource.project, resource), params: { resource: { name: "New name" } }
    assert_redirected_to project_resource_path(resource.project, resource)
    resource.reload
    assert_equal "New name", resource.name
  end

  test "should not update resource" do
    resource = create(:resource)
    name = resource.name
    put project_resource_path(resource.project, resource), params: { resource: { name: "" } }
    assert_response :unprocessable_entity
    resource.reload
    assert_equal name, resource.name
  end

  test "should not update resource (not authenticated)" do
    sign_out :user
    resource = create(:resource)
    resource_original_name = resource.name
    put project_resource_path(resource.project, resource), params: { resource: { name: "New name" } }
    resource.reload
    assert_equal resource_original_name, resource.name
    assert_redirected_to new_user_session_path
  end

  test "should delete resource" do
    resource = create(:resource)
    project = resource.project
    assert_difference 'Resource.count', -1 do
      delete project_resource_path(project, resource)
    end
    assert_redirected_to project_resources_path(project)
  end

  test "should not delete resource (foreign key constraint)" do
    resource = create(:resource)
    project = resource.project
    create(:attribute_with_resource, resource: resource)
    assert_no_difference('Resource.count') do
      delete project_resource_path(project, resource)
    end
    assert_response :conflict
  end

  test "should not delete resource (not authenticated)" do
    sign_out :user
    resource = create(:resource)
    project = resource.project
    assert_no_difference 'Resource.count' do
      delete project_resource_path(project, resource)
    end
    assert_redirected_to new_user_session_path
  end


  test "should get kotlin code" do
    resource = create(:resource, name: 'Pokemon', project: create(:project, title: 'PokeApi'))
    resource.resource_attributes << create(:attribute, name: 'id', primitive_type: :integer)
    resource.resource_attributes << create(:attribute, name: 'weight', primitive_type: :number, nullable: true)
    resource.resource_attributes << create(:attribute_with_resource, name: 'weakness_list', resource: create(:resource, name: 'nature'), is_array: true)

    file = "package com.applidium.pokeapi.android.data.net.retrofit.model\n"
    file += "\n"
    file += "data class RestPokemon(\n"
    file += "    val id: Int,\n"
    file += "    val weaknessList: List<RestNature>,\n"
    file += "    val weight: Double?\n"
    file += ")\n"

    get project_resource_path(resource.project, resource, format: 'kotlin')
    assert_equal(response.body, file)
  end

  test "should get java code" do
    resource = create(:resource, name: 'Pokemon', project: create(:project, title: 'PokeApi'))
    resource.resource_attributes << create(:attribute, name: 'id', primitive_type: :integer)
    resource.resource_attributes << create(:attribute, name: 'weight', primitive_type: :number, nullable: true)
    resource.resource_attributes << create(:attribute_with_resource, name: 'weakness_list', resource: create(:resource, name: 'nature'), is_array: true)

    file = "package com.applidium.pokeapi.android.data.net.retrofit.model\n"
    file += "\n"
    file += "import android.support.annotation.Nullable;\n"
    file += "\n"
    file += "import java.util.List;\n"
    file += "\n"
    file += "import io.norberg.automatter.AutoMatter;\n"
    file += "\n"
    file += "@AutoMatter\n"
    file += "public interface RestPokemon {\n"
    file += "    Integer id();\n"
    file += "    List<RestNature> weaknessList();\n"
    file += "    @Nullable Double weight();\n"
    file += "}\n"

    get project_resource_path(resource.project, resource, format: 'java')
    assert_equal(response.body, file)
  end
end