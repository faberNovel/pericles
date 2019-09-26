require 'test_helper'

class ResourcesControllerTest < ControllerWithAuthenticationTest
  include AndroidCodeGenHelper

  setup do
    @project = create(:project)
  end

  test 'should get index' do
    create(:resource, name: 'Second', project: @project)
    create(:resource, name: 'First', project: @project)
    get project_resources_path(@project)
    assert_response :success
  end

  test 'should get index json' do
    create(:resource, name: 'Second', project: @project)
    create(:resource, name: 'First', project: @project)
    get project_resources_path(@project, format: 'json')
    assert_response :success
  end

  test 'should not get index (not authenticated)' do
    sign_out :user
    get project_resources_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should show resource' do
    resource = create(:resource_with_attributes)
    get project_resource_path(resource.project, resource)
    assert_response :success
  end

  test 'should get resource json' do
    resource = create(:pokemon)
    get project_resource_path(resource.project, resource, format: :json)
    assert_response :success
  end

  test 'should not show resource (not authenticated)' do
    sign_out :user
    resource = create(:resource_with_attributes)
    get project_resource_path(resource.project, resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should get new' do
    get new_project_resource_path(@project)
    assert_response :success
  end

  test 'should not get new (not authenticated)' do
    sign_out :user
    get new_project_resource_path(@project)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should get edit resource' do
    resource = create(:resource)
    get edit_resource_project_resource_path(resource.project, resource)
    assert_response :success
  end

  test 'should not get edit resource (not authenticated)' do
    sign_out :user
    resource = create(:resource)
    get edit_resource_project_resource_path(resource.project, resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should get edit attributes' do
    resource = create(:resource)
    get edit_attributes_project_resource_path(resource.project, resource)
    assert_response :success
  end

  test 'should not get edit attributes (not authenticated)' do
    sign_out :user
    resource = create(:resource)
    get edit_attributes_project_resource_path(resource.project, resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should create resource' do
    resource = build(:resource)
    assert_difference('Resource.count') do
      post project_resources_path(resource.project), params: { resource: resource.attributes }
    end
    resource = assigns[:resource]
    assert_not_nil resource, 'should create resource'
    assert_redirected_to project_resource_path(resource.project, resource)
  end

  test 'should create resource from json' do
    assert_difference('Resource.count') do
      post project_resources_path(@project), params: {
        resource: { name: 'Resource name' }, json_instance: '{"id": 1}'
      }
    end
    assert_redirected_to project_resource_path(@project, @project.resources.order(:created_at).last)
  end

  test 'should not create resource from invalid json' do
    assert_no_difference('Resource.count') do
      post project_resources_path(@project), params: {
        resource: { name: 'Resource name', json_instance: '{invalid}' }
      }
    end
    assert_response :unprocessable_entity
  end

  test 'should create resource from json that is not an object' do
    assert_no_difference('Resource.count') do
      post project_resources_path(@project), params: {
        resource: { name: 'Resource name', json_instance: '"valid json as string"' }
      }
    end
    assert_response :unprocessable_entity
  end

  test 'should not create resource without a name' do
    resource = build(:resource)
    resource.name = ''
    assert_no_difference('Resource.count') do
      post project_resources_path(resource.project), params: { resource: resource.attributes }
    end
    assert_response :unprocessable_entity
  end

  test 'should not create resource (not authenticated)' do
    sign_out :user
    resource = build(:resource)
    assert_no_difference('Resource.count') do
      post project_resources_path(resource.project), params: { resource: resource.attributes }
    end
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should update resource' do
    resource = create(:resource)
    put project_resource_path(resource.project, resource), params: { resource: { name: 'New name' } }
    assert_redirected_to project_resource_path(resource.project, resource)
    resource.reload
    assert_equal 'New name', resource.name
  end

  test 'should not update resource' do
    resource = create(:resource)
    name = resource.name
    put project_resource_path(resource.project, resource), params: { resource: { name: '' } }
    assert_response :unprocessable_entity
    resource.reload
    assert_equal name, resource.name
  end

  test 'should update resource attributes using type to reference another resource' do
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

  test 'should update resource attributes using type as primitive_type' do
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

  test 'adding attribute with same name fails' do
    resource = create(:resource_with_attributes)
    a = resource.resource_attributes.first

    assert_no_difference 'Attribute.count' do
      put project_resource_path(resource.project, resource), params: {
        resource: {
          resource_attributes_attributes: {
            0 => {
              name: a.name,
              type: a.type
            }
          }
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test 'renaming attribute with same name fails' do
    resource = create(:resource)
    a = create(:attribute, parent_resource: resource)
    b = create(:attribute, parent_resource: resource)

    assert_no_difference 'Attribute.count' do
      put project_resource_path(resource.project, resource), params: {
        resource: {
          resource_attributes_attributes: {
            0 => {
              id: a.id,
              name: a.name,
              type: a.type
            },
            1 => {
              id: b.id,
              name: a.name,
              type: b.type
            }
          }
        }
      }
    end

    assert_equal 1, response.body.scan(/taken/).count
    assert_response :unprocessable_entity
  end

  test 'deleted then created attribute is not flagged as error if we add attribute with same name' do
    resource = create(:resource_with_attributes)
    same_name = resource.resource_attributes.first
    deleted_then_created = create(:attribute, parent_resource: resource)

    assert_no_difference 'Attribute.count' do
      put project_resource_path(resource.project, resource), params: {
        resource: {
          resource_attributes_attributes: {
            0 => {
              id: same_name.id,
              name: same_name.name,
              type: same_name.type
            },
            1 => {
              name: same_name.name,
              type: same_name.type
            },
            2 => {
              id: deleted_then_created.id,
              _destroy: true
            },
            3 => {
              name: deleted_then_created.name,
              type: deleted_then_created.type
            }
          }
        }
      }
    end

    assert_response :unprocessable_entity
    assert_equal 1, response.body.scan(/taken/).count
  end


  test 'destroy attribute and adding attribute with the same name' do
    resource = create(:resource_with_attributes)
    a = resource.resource_attributes.first

    assert_no_difference 'Attribute.count' do
      put project_resource_path(resource.project, resource), params: {
        resource: {
          resource_attributes_attributes: {
            0 => {
              id: a.id,
              _destroy: true,
            },
            1 => {
              name: a.name,
              type: a.type
            }
          }
        }
      }
    end

    assert_redirected_to project_resource_path(resource.project, resource)
    assert_not Attribute.exists?(a.id)
  end

  test 'swap two attributes names' do
    resource = create(:resource)
    a = create(:attribute, parent_resource: resource, name: 'a')
    b = create(:attribute, parent_resource: resource, name: 'b')

    assert_no_difference 'Attribute.count' do
      put project_resource_path(resource.project, resource), params: {
        resource: {
          resource_attributes_attributes: {
            0 => {
              id: a.id,
              name: b.name,
              type: a.type
            },
            1 => {
              id: b.id,
              name: a.name,
              type: b.type
            }
          }
        }
      }
    end

    assert_redirected_to project_resource_path(resource.project, resource)
    assert_equal a.reload.name, 'b'
    assert_equal b.reload.name, 'a'
  end

  test 'should not update resource (not authenticated)' do
    sign_out :user
    resource = create(:resource)
    resource_original_name = resource.name
    put project_resource_path(resource.project, resource), params: { resource: { name: 'New name' } }
    resource.reload
    assert_equal resource_original_name, resource.name
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should delete resource' do
    resource = create(:resource)
    project = resource.project
    assert_difference 'Resource.count', -1 do
      delete project_resource_path(project, resource)
    end
    assert_redirected_to project_resources_path(project)
  end

  test 'should not delete resource (foreign key constraint)' do
    resource = create(:resource)
    project = resource.project
    create(:attribute_with_resource, resource: resource)
    assert_no_difference('Resource.count') do
      delete project_resource_path(project, resource)
    end
    assert_response :conflict
  end

  test 'should not delete resource (not authenticated)' do
    sign_out :user
    resource = create(:resource)
    project = resource.project
    assert_no_difference 'Resource.count' do
      delete project_resource_path(project, resource)
    end
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should get kotlin code' do
    resource = create(:pokemon)

    file = %{package #{android_company_domain_name}.pokeapi.android.data.net.retrofit.model

    data class RestPokemon(
        val date: String,
        val dateTime: String?,
        val id: Int,
        val mindset: String?,
        val nature: RestNature,
        val niceBoolean: Boolean?,
        val weaknessList: List<RestNature>,
        val weight: Double?
    )
    }.gsub(/^    /, '')

    get project_resource_path(resource.project, resource, format: 'kotlin')
    assert_equal(response.body, file)
  end

  test 'should get swift code' do
    resource = create(:pokemon)

    file = %(//
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
        let mindset: String?
        let nature: RestNature
        let niceBoolean: Bool?
        let weaknessList: [RestNature]
        let weight: Double?

        enum CodingKeys : String, CodingKey {
            case date
            case dateTime = \"date_time\"
            case id
            case mindset
            case nature
            case niceBoolean
            case weaknessList = \"weakness_list\"
            case weight
        }
    }
    ).gsub(/^    /, '')
    travel_to Date.new(2017, 12, 1) do
      get project_resource_path(resource.project, resource, format: 'swift')
    end
    assert_equal(response.body, file)
  end

  test 'should get ruby code' do
    resource = create(:pokemon)

    file = %(class PokemonSerializer < ActiveModel::Serializer
      attributes(
        :date,
        :date_time,
        :id,
        :mindset,
        :nice_boolean,
        :weight,
      )

      has_many :weakness_list, serializer: NatureSerializer
      belongs_to :nature, serializer: NatureSerializer
    end
    ).gsub(/^    /, '')
    get project_resource_path(resource.project, resource, format: 'ruby')
    assert_equal(response.body, file)
  end

  test 'should get typescript code' do
    resource = create(:pokemon)

    file = %(import { RestNature, Nature } from "./nature";

    export interface RestPokemon {
      readonly date: string;
      readonly date_time?: string;
      readonly id: number;
      readonly mindset?: "calm" | "angry";
      readonly nature: RestNature;
      readonly niceBoolean?: boolean;
      readonly weakness_list: ReadonlyArray<RestNature>;
      readonly weight?: number;
    }

    export class Pokemon {
      public readonly date: string;
      public readonly dateTime?: string;
      public readonly id: number;
      public readonly mindset?: "calm" | "angry";
      public readonly nature: Nature;
      public readonly niceBoolean?: boolean;
      public readonly weaknessList: ReadonlyArray<Nature>;
      public readonly weight?: number;

      public constructor(json: RestPokemon) {
        this.date = json.date;
        this.dateTime = (json.date_time !== null && json.date_time !== undefined) ? json.date_time : undefined;
        this.id = json.id;
        this.mindset = (json.mindset !== null && json.mindset !== undefined) ? json.mindset : undefined;
        this.nature = new Nature(json.nature);
        this.niceBoolean = json.niceBoolean !== undefined && json.niceBoolean !== null && json.niceBoolean;
        this.weaknessList = json.weakness_list.map((o) => new Nature(o));
        this.weight = (json.weight !== null && json.weight !== undefined) ? json.weight : undefined;
      }
    }
    ).gsub(/^    /, '')
    get project_resource_path(resource.project, resource, format: 'typescript')
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

    put project_resource_path(resource.project, resource), params: { resource: { name: 'New name' } }
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

    put project_resource_path(resource.project, resource), params: { resource: { name: 'New name' } }
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

    put project_resource_path(resource.project, resource), params: { resource: { name: 'New name' } }
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

    put project_resource_path(resource.project, resource), params: { resource: { name: 'New name' } }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    delete project_resource_path(project, resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end
end
