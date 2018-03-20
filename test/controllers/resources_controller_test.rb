require 'test_helper'

class ResourcesControllerTest < ControllerWithAuthenticationTest
  include AndroidCodeGenHelper

  setup do
    @project = create(:project)
  end

  test "should get index" do
    create(:resource, name: "Second", project: @project)
    create(:resource, name: "First", project: @project)
    get project_resources_path(@project)
    assert_response :success
  end

  test "should get index json" do
    create(:resource, name: "Second", project: @project)
    create(:resource, name: "First", project: @project)
    get project_resources_path(@project, format: 'json')
    assert_response :success
  end


  test "should not get index (not authenticated)" do
    sign_out :user
    get project_resources_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test "should show resource" do
    resource = create(:resource_with_attributes)
    get project_resource_path(resource.project, resource)
    assert_response :success
  end

  test "should get resource json" do
    resource = create(:pokemon)
    get project_resource_path(resource.project, resource, format: :json)
    assert_response :success
  end

  test "should not show resource (not authenticated)" do
    sign_out :user
    resource = create(:resource_with_attributes)
    get project_resource_path(resource.project, resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test "should get new" do
    get new_project_resource_path(@project)
    assert_response :success
  end

  test "should not get new (not authenticated)" do
    sign_out :user
    get new_project_resource_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test "should get edit resource" do
    resource = create(:resource)
    get edit_resource_project_resource_path(resource.project, resource)
    assert_response :success
  end

  test "should not get edit resource (not authenticated)" do
    sign_out :user
    resource = create(:resource)
    get edit_resource_project_resource_path(resource.project, resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test "should get edit attributes" do
    resource = create(:resource)
    get edit_attributes_project_resource_path(resource.project, resource)
    assert_response :success
  end

  test "should not get edit attributes (not authenticated)" do
    sign_out :user
    resource = create(:resource)
    get edit_attributes_project_resource_path(resource.project, resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
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

  test "should create resource from json" do
    assert_difference('Resource.count') do
      post project_resources_path(@project), params: {
        resource: {name: 'Resource name'}, json_instance: '{"id": 1}'
      }
    end
    assert_redirected_to project_resource_path(@project, @project.resources.order(:created_at).last)
  end

  test "should create resource from invalid json" do
    assert_no_difference('Resource.count') do
      post project_resources_path(@project), params: {
        resource: {name: 'Resource name'}, json_instance: '{invalid}'
      }
    end
    assert_response :unprocessable_entity
  end

  test "should create resource from json that is not an object" do
    assert_no_difference('Resource.count') do
      post project_resources_path(@project), params: {
        resource: {name: 'Resource name'}, json_instance: '"valid json as string"'
      }
    end
    assert_response :unprocessable_entity
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
    assert_redirected_to new_user_session_path(redirect_to: request.path)
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

  test "should update resource attributes using type to reference another resource" do
    resource = create(:resource_with_attributes)
    referenced_resource = create(:resource)
    a = resource.resource_attributes.first
    a.update(primitive_type: :integer)
    assert_not_equal a.reload.resource_id, referenced_resource.id

    put project_resource_path(resource.project, resource), params: {
      resource: {
        resource_attributes_attributes: {
          0 => {
            id: a.id,
            type: referenced_resource.id
          }
        }
      }
    }
    assert_equal a.reload.resource_id, referenced_resource.id
  end

  test "should update resource attributes using type as primitive_type" do
    resource = create(:resource_with_attributes)
    a = resource.resource_attributes.first
    a.update(primitive_type: :string)
    assert_not a.reload.integer?

    put project_resource_path(resource.project, resource), params: {
      resource: {
        resource_attributes_attributes: {
          0 => {
            id: a.id,
            type: 'integer'
          }
        }
      }
    }
    assert a.reload.integer?
  end

  test "should not update resource (not authenticated)" do
    sign_out :user
    resource = create(:resource)
    resource_original_name = resource.name
    put project_resource_path(resource.project, resource), params: { resource: { name: "New name" } }
    resource.reload
    assert_equal resource_original_name, resource.name
    assert_redirected_to new_user_session_path(redirect_to: request.path)
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
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end


  test "should get kotlin code" do
    resource = create(:pokemon)

    file = %{package #{android_company_domain_name}.pokeapi.android.data.net.retrofit.model

    data class RestPokemon(
        val date: String,
        val dateTime: String?,
        val id: Int,
        val niceBoolean: Boolean?,
        val weaknessList: List<RestNature>,
        val weight: Double?
    )
    }.gsub(/^    /, '')

    get project_resource_path(resource.project, resource, format: 'kotlin')
    assert_equal(response.body, file)
  end

  test "should get java code" do
    resource = create(:pokemon)

    file = %{package #{android_company_domain_name}.pokeapi.android.data.net.retrofit.model

    import android.support.annotation.Nullable;

    import java.util.List;

    import io.norberg.automatter.AutoMatter;

    @AutoMatter
    public interface RestPokemon {
        String date();
        @Nullable String dateTime();
        Integer id();
        @Nullable Boolean niceBoolean();
        List<RestNature> weaknessList();
        @Nullable Double weight();
    }
    }.gsub(/^    /, '')

    get project_resource_path(resource.project, resource, format: 'java')
    assert_equal(response.body, file)
  end

  test "should get swift code" do
    resource = create(:pokemon)

    file = %{//
    //  RestPokemon.swift
    //
    //  Generated by Pericles on 01/12/2017
    //
    //

    import Foundation

    struct RestPokemon : Decodable {
        let date: Date
        let dateTime: Date?
        let id: Int
        let niceBoolean: Bool?
        let weaknessList: [RestNature]
        let weight: Double?

        enum CodingKeys : String, CodingKey {
            case date
            case dateTime = \"date_time\"
            case id
            case niceBoolean
            case weaknessList = \"weakness_list\"
            case weight
        }
    }
    }.gsub(/^    /, '')
    travel_to Date.new(2017, 12, 1) do
      get project_resource_path(resource.project, resource, format: 'swift')
    end
    assert_equal(response.body, file)
  end

  test 'non member external user should not access project resources' do
    external_user = create(:user, :external)
    sign_in external_user

    resource = create(:resource)
    project = resource.project

    get project_resources_path(project)
    assert_response :forbidden

    get new_project_resource_path(project)
    assert_response :forbidden

    post project_resources_path(resource.project), params: { resource: build(:resource).attributes }
    assert_response :forbidden

    get project_resource_path(project, resource)
    assert_response :forbidden

    get edit_attributes_project_resource_path(project, resource)
    assert_response :forbidden

    get edit_resource_project_resource_path(project, resource)
    assert_response :forbidden

    put project_resource_path(resource.project, resource), params: { resource: { name: "New name" } }
    assert_response :forbidden

    delete project_resource_path(project, resource)
    assert_response :forbidden
  end

  test 'member external user should access project resources' do
    external_user = create(:user, :external)
    sign_in external_user

    resource = create(:resource)
    project = resource.project
    create(:member, project: project, user: external_user)

    get project_resources_path(project)
    assert_response :success

    get new_project_resource_path(project)
    assert_response :success

    post project_resources_path(resource.project), params: { resource: build(:resource).attributes }
    created = Resource.order(:created_at).last
    assert_redirected_to project_resource_path(created.project, created)

    get project_resource_path(project, resource)
    assert_response :success

    get edit_attributes_project_resource_path(project, resource)
    assert_response :success

    get edit_resource_project_resource_path(project, resource)
    assert_response :success

    put project_resource_path(resource.project, resource), params: { resource: { name: "New name" } }
    assert_redirected_to project_resource_path(resource.project, resource)

    delete project_resource_path(project, resource)
    assert_redirected_to project_resources_path(project)
  end

  test 'non member external user should access public project resources with read-only permission' do
    external_user = create(:user, :external)
    sign_in external_user

    resource = create(:resource)
    project = resource.project
    project.update(is_public: true)

    get project_resources_path(project)
    assert_response :success

    get new_project_resource_path(project)
    assert_response :forbidden

    post project_resources_path(resource.project), params: { resource: build(:resource).attributes }
    assert_response :forbidden

    get project_resource_path(project, resource)
    assert_response :success

    get edit_attributes_project_resource_path(project, resource)
    assert_response :forbidden

    get edit_resource_project_resource_path(project, resource)
    assert_response :forbidden

    put project_resource_path(resource.project, resource), params: { resource: { name: "New name" } }
    assert_response :forbidden

    delete project_resource_path(project, resource)
    assert_response :forbidden
  end

  test 'unauthenticated user should access public project resources with read-only permission' do
    sign_out :user

    resource = create(:resource)
    project = resource.project
    project.update(is_public: true)

    get project_resources_path(project)
    assert_response :success

    get new_project_resource_path(project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    post project_resources_path(resource.project), params: { resource: build(:resource).attributes }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get project_resource_path(project, resource)
    assert_response :success

    get edit_attributes_project_resource_path(project, resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get edit_resource_project_resource_path(project, resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    put project_resource_path(resource.project, resource), params: { resource: { name: "New name" } }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    delete project_resource_path(project, resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end
end
