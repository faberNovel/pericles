require 'test_helper'

class ResourceRepresentationsControllerTest < ControllerWithAuthenticationTest
  setup do
    @project = create(:project)
    @resource = create(:resource_with_attributes, project: @project)
    @representation = create(:resource_representation_with_attributes_resource_reps, resource: @resource)
  end

  test 'should get new' do
    get new_resource_resource_representation_path(@resource)
    assert_response :success
  end

  test 'should not get new (not authenticated)' do
    sign_out :user
    get new_resource_resource_representation_path(@resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'get random json from representation' do
    @representation.attributes_resource_representations.update(is_required: true)
    get random_resource_resource_representation_path(@resource, @representation)

    json = JSON.parse(response.body)
    assert json
    assert_not_nil json[@representation.attributes_resource_representations.first.key_name]
  end

  test 'should get edit' do
    get edit_resource_resource_representation_path(@resource, @representation)
    assert_response :success
  end

  test 'should not get edit (not authenticated)' do
    sign_out :user
    get edit_resource_resource_representation_path(@resource, @representation)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should create resource_representation' do
    @representation = build(:resource_representation)

    assert_difference('ResourceRepresentation.count') do
      post resource_resource_representations_path(@resource), params: {
        resource_representation: res_rep_params_hash
      }
    end

    assert_redirected_to project_resource_path(@project, @resource)
  end

  test 'should create resource_representation with attributes_resource_representations' do
    @representation = build(:resource_representation_with_attributes_resource_reps, resource: @resource)
    count = @representation.attributes_resource_representations.length
    assert_not count.zero?

    assert_difference('AttributesResourceRepresentation.count', count) do
      post resource_resource_representations_path(@resource), params: {
        resource_representation: res_rep_params_hash
      }
    end

    assert_redirected_to project_resource_path(@project, @resource)
  end

  test 'should not create resource_representation without a name' do
    @representation = build(:resource_representation, name: '')

    assert_no_difference('ResourceRepresentation.count') do
      post resource_resource_representations_path(@resource), params: {
        resource_representation: @representation.attributes
      }
    end
    assert_response :unprocessable_entity
  end

  test 'should not create resource_representation (not authenticated)' do
    @representation = build(:resource_representation)
    sign_out :user

    assert_no_difference('ResourceRepresentation.count') do
      post resource_resource_representations_path(@resource), params: {
        resource_representation: res_rep_params_hash
      }
    end

    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should update resource_representation' do
    assert_not_equal 'New name', @representation.name

    put resource_resource_representation_path(@resource, @representation), params: {
      resource_representation: {
        name: 'New name'
      }
    }

    assert_redirected_to project_resource_path(@project, @resource)
    assert_equal 'New name', @representation.reload.name
  end

  test 'cannot update resource_representation with empty name' do
    old_name = @representation.name
    assert_not_equal old_name, ''

    put resource_resource_representation_path(@resource, @representation), params: {
      resource_representation: {
        name: ''
      }
    }

    assert_response :unprocessable_entity
    assert_equal old_name, @representation.reload.name
  end

  test 'cannot update resource_representation if not authenticated' do
    old_name = @representation.name
    assert_not_equal old_name, 'new_name'
    sign_out :user

    put resource_resource_representation_path(@resource, @representation), params: {
      resource_representation: {
        name: 'new_name'
      }
    }

    assert_redirected_to new_user_session_path(redirect_to: request.path)
    assert_equal old_name, @representation.reload.name
  end

  test 'should delete resource_representation' do
    assert_difference 'ResourceRepresentation.count', -1 do
      delete resource_resource_representation_path(@resource, @representation)
    end

    assert_redirected_to project_resource_path(@project, @resource)
  end

  test 'should not delete resource_representation used in response' do
    create(:response,
      route: create(:route, resource: @resource),
      resource_representation: @representation
    )

    assert_no_difference('ResourceRepresentation.count') do
      delete resource_resource_representation_path(@resource, @representation)
    end

    assert_redirected_to project_resource_path(@project, @resource)
  end

  test 'should not delete resource_representation if not authenticated' do
    sign_out :user

    assert_no_difference('ResourceRepresentation.count') do
      delete resource_resource_representation_path(@resource, @representation)
    end
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'should get json schema associated to resource_representation' do
    resource = create(:resource, name: 'Movie', description: 'A movie')
    attribute = create(:attribute,
      parent_resource: resource,
      name: 'main_title',
      description: 'title of the film',
      primitive_type: :string,
      enum: 'The Godfather, Finding Nemo',
      scheme: create(:scheme, regexp: 'The Godfather II')
    )
    resource_representation = create(:resource_representation, resource: resource)
    create(:attributes_resource_representation,
      parent_resource_representation: resource_representation,
      resource_attribute: attribute,
      is_required: true
    )
    json_schema = JSONSchemaBuilder.new(
      resource_representation,
      is_collection: false,
      root_key: 'movie'
    ).execute

    get resource_resource_representation_path(resource, resource_representation, format: :json_schema, root_key: 'movie')
    assert_equal json_schema.deep_stringify_keys!, JSON.parse(response.body), 'json schema is not correct'
  end

  test 'should not get json schema associated to resource_representation if not authenticated' do
    sign_out :user

    get resource_resource_representation_path(@resource, @representation, format: :json_schema)

    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end

  test 'clone should create new resource_representation' do
    assert_difference 'ResourceRepresentation.count' do
      post resource_resource_representation_clone_path(@resource, @representation)
    end
  end

  test 'clone should create new attributes_resource_representation' do
    count = @representation.attributes_resource_representations.count
    assert_difference 'AttributesResourceRepresentation.count', count do
      post resource_resource_representation_clone_path(@resource, @representation)
    end
  end

  test 'member external user should access project resource_representation' do
    external_user = create(:user, :external)
    create(:member, project: @project, user: external_user)
    sign_in external_user

    get new_resource_resource_representation_path(@resource)
    assert_response :success

    put resource_resource_representation_path(@resource, @representation), params: {
      resource_representation: {
        name: 'New name'
      }
    }
    assert_redirected_to project_resource_path(@project, @resource)

    post resource_resource_representations_path(@resource), params: {
      resource_representation: res_rep_params_hash
    }
    assert_redirected_to project_resource_path(@project, @resource)

    get edit_resource_resource_representation_path(@resource, @representation)
    assert_response :success

    post resource_resource_representation_clone_path(@resource, @representation)
    assert_redirected_to project_resource_path(@project, @resource)

    delete resource_resource_representation_path(@resource, @representation)
    assert_redirected_to project_resource_path(@project, @resource)
  end

  test 'non member external user should not access project resource_representation' do
    external_user = create(:user, :external)
    sign_in external_user

    get new_resource_resource_representation_path(@resource)
    assert_response :forbidden

    put resource_resource_representation_path(@resource, @representation), params: {
      resource_representation: {
        name: 'New name'
      }
    }
    assert_response :forbidden

    post resource_resource_representations_path(@resource), params: {
      resource_representation: res_rep_params_hash
    }
    assert_response :forbidden

    get edit_resource_resource_representation_path(@resource, @representation)
    assert_response :forbidden

    post resource_resource_representation_clone_path(@resource, @representation)
    assert_response :forbidden
  end

  test 'non member external user should access public project resource_representation with read-only permission' do
    external_user = create(:user, :external)
    @project.update(is_public: true)
    sign_in external_user

    get new_resource_resource_representation_path(@resource)
    assert_response :forbidden

    put resource_resource_representation_path(@resource, @representation), params: {
      resource_representation: {
        name: 'New name'
      }
    }
    assert_response :forbidden

    post resource_resource_representations_path(@resource), params: {
      resource_representation: res_rep_params_hash
    }
    assert_response :forbidden

    get edit_resource_resource_representation_path(@resource, @representation)
    assert_response :forbidden

    post resource_resource_representation_clone_path(@resource, @representation)
    assert_response :forbidden
  end

  test 'unauthenticated user should access public project resource_representation with read-only permission' do
    @project.update(is_public: true)
    sign_out :user

    get new_resource_resource_representation_path(@resource)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    put resource_resource_representation_path(@resource, @representation), params: {
      resource_representation: {
        name: 'New name'
      }
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    post resource_resource_representations_path(@resource), params: {
      resource_representation: res_rep_params_hash
    }
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    get edit_resource_resource_representation_path(@resource, @representation)
    assert_redirected_to new_user_session_path(redirect_to: request.path)

    post resource_resource_representation_clone_path(@resource, @representation)
    assert_redirected_to new_user_session_path(redirect_to: request.path)
  end


  test 'get typescript resource representation' do
    resource = create(:pokemon)
    representation = resource.resource_representations.first
    create(:attributes_resource_representation, attribute_id: resource.resource_attributes.find(&:boolean?).id, parent_resource_representation: representation)

    file = %(import { RestDefaultNature, DefaultNature } from "./default_nature";

    export interface RestDefaultPokemon {
      readonly date: string;
      readonly date_time?: string;
      readonly id: number;
      readonly mindset?: "calm" | "angry";
      readonly nature: RestDefaultNature;
      readonly niceBoolean?: boolean;
      readonly weakness_list: ReadonlyArray<RestDefaultNature>;
      readonly weight?: number;
    }

    export class DefaultPokemon {
      public readonly date: string;
      public readonly dateTime?: string;
      public readonly id: number;
      public readonly mindset?: "calm" | "angry";
      public readonly nature: DefaultNature;
      public readonly niceBoolean?: boolean;
      public readonly weaknessList: ReadonlyArray<DefaultNature>;
      public readonly weight?: number;

      public constructor(json: RestDefaultPokemon) {
        this.date = json.date;
        this.dateTime = (json.date_time !== null && json.date_time !== undefined) ? json.date_time : undefined;
        this.id = json.id;
        this.mindset = (json.mindset !== null && json.mindset !== undefined) ? json.mindset : undefined;
        this.nature = new DefaultNature(json.nature);
        this.niceBoolean = json.niceBoolean !== undefined && json.niceBoolean !== null && json.niceBoolean;
        this.weaknessList = json.weakness_list.map((o) => new DefaultNature(o));
        this.weight = (json.weight !== null && json.weight !== undefined) ? json.weight : undefined;
      }
    }
    ).gsub(/^    /, '')
    get resource_resource_representation_path(resource, representation, format: :typescript)
    assert_equal(response.body, file)
  end

  private

  def res_rep_params_hash
    representation_hash = @representation.attributes

    associations_to_attributes_hash = {}
    @representation.attributes_resource_representations.each_with_index do |association, index|
      associations_to_attributes_hash[index.to_s] = association.attributes.merge!({ '_destroy' => '0' })
    end

    representation_hash['attributes_resource_representations_attributes'] = associations_to_attributes_hash
    representation_hash
  end
end
