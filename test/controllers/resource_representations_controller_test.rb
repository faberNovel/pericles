require 'test_helper'

class ResourceRepresentationsControllerTest < ControllerWithAuthenticationTest

  test "should show resource_representation" do
    representation = create(:resource_representation)
    get resource_resource_representation_path(representation.resource, representation)
    assert_response :success
  end

  test "should not show resource_representation (not authenticated)" do
    sign_out :user
    representation = create(:resource_representation)
    get resource_resource_representation_path(representation.resource, representation)
    assert_redirected_to new_user_session_path
  end

  test "should get new" do
    resource = create(:resource)
    get new_resource_resource_representation_path(resource)
    assert_response :success
  end

  test "should not get new (not authenticated)" do
    sign_out :user
    resource = create(:resource)
    get new_resource_resource_representation_path(resource)
    assert_redirected_to new_user_session_path
  end

  test "should get edit" do
    representation = create(:resource_representation_with_attributes_resource_reps)
    get edit_resource_resource_representation_path(representation.resource, representation)
    assert_response :success
  end

  test "should not get edit (not authenticated)" do
    sign_out :user
    representation = create(:resource_representation_with_attributes_resource_reps)
    get edit_resource_resource_representation_path(representation.resource, representation)
    assert_redirected_to new_user_session_path
  end

  test "should create resource_representation" do
    resource_representation = build(:resource_representation)
    resource = resource_representation.resource
    assert_difference('ResourceRepresentation.count') do
      post resource_resource_representations_path(resource),
      params: { resource_representation: resource_representation.attributes }
    end
    representation = assigns(:representation)
    assert_not_nil representation, "should create resource_representation"
    assert_redirected_to resource_resource_representation_path(resource, representation)
  end

  test "should create resource_representation with attributes_resource_representations" do
    resource_representation = build(:resource_representation_with_attributes_resource_reps)
    res_rep_params_hash = create_representation_hash_with_associations_to_attributes(resource_representation)
    resource = resource_representation.resource
    assert_difference('ResourceRepresentation.count') do
      post resource_resource_representations_path(resource), params: { resource_representation: res_rep_params_hash }
    end
    representation = assigns(:representation)
    assert_not_nil representation, "should create resource_representation"
    assert_redirected_to resource_resource_representation_path(resource, representation)
  end

  test "should not create resource_representation without a name" do
    resource_representation = build(:resource_representation)
    resource = resource_representation.resource
    resource_representation.name = ''
    assert_no_difference('ResourceRepresentation.count') do
      post resource_resource_representations_path(resource),
      params: { resource_representation: resource_representation.attributes }
    end
    assert_response :unprocessable_entity
  end

  test "should not create resource_representation (not authenticated)" do
    sign_out :user
    resource_representation = build(:resource_representation)
    resource = resource_representation.resource
    assert_no_difference('ResourceRepresentation.count') do
      post resource_resource_representations_path(resource),
      params: { resource_representation: resource_representation.attributes }
    end
    assert_redirected_to new_user_session_path
  end

  test "should update resource_representation" do
    resource_representation = create(:resource_representation)
    resource = resource_representation.resource
    put resource_resource_representation_path(resource, resource_representation),
      params: { resource_representation: { name: 'Modified resource representation' } }
    assert_redirected_to resource_resource_representation_path(resource, resource_representation)
    resource_representation.reload
    assert_equal 'Modified resource representation', resource_representation.name
  end

  test "should not update resource_representation" do
    resource = create(:resource_with_attributes)
    resource_representation = create(:resource_representation, resource: resource)
    name = resource_representation.name
    put resource_resource_representation_path(resource_representation.resource, resource_representation), params: { resource_representation: { name: '' } }
    assert_response :unprocessable_entity
    resource_representation.reload
    assert_equal name, resource_representation.name
  end

  test "should not update resource_representation (not authenticated)" do
    sign_out :user
    resource_representation = create(:resource_representation)
    resource = resource_representation.resource
    resource_rep_original_name = resource_representation.name
    put resource_resource_representation_path(resource, resource_representation),
      params: { resource_representation: { name: 'Modified resource representation' } }
    resource_representation.reload
    assert_equal resource_rep_original_name, resource_representation.name
    assert_redirected_to new_user_session_path
  end

  test "should delete resource_representation" do
    resource_representation = create(:resource_representation)
    project = resource_representation.resource.project
    resource = resource_representation.resource
    assert_difference 'ResourceRepresentation.count', -1 do
      delete resource_resource_representation_path(resource, resource_representation)
    end
    assert_redirected_to project_resource_path(project, resource)
  end

  test "should not delete resource_representation (foreign key constraint)" do
    resource_representation = create(:resource_representation)
    resource = resource_representation.resource
    route = create(:route, resource: resource)
    create(:response, route: route, resource_representation: resource_representation)
    assert_no_difference('ResourceRepresentation.count') do
      delete resource_resource_representation_path(resource, resource_representation)
    end
    assert_response :conflict
  end

  test "should not delete resource_representation (not authenticated)" do
    sign_out :user
    resource_representation = create(:resource_representation)
    resource = resource_representation.resource
    assert_no_difference('ResourceRepresentation.count') do
      delete resource_resource_representation_path(resource, resource_representation)
    end
    assert_redirected_to new_user_session_path
  end

  test 'should get json schema associated to resource_representation' do
    resource = create(:resource, name: 'Movie', description: 'A movie')
    attribute = create(:attribute, parent_resource: resource, name: 'main_title', description: 'title of the film',
     primitive_type: :string, enum: "The Godfather, Finding Nemo", pattern: "The Godfather")
    resource_representation = create(:resource_representation, resource: resource)
    create(:attributes_resource_representation, parent_resource_representation: resource_representation,
     resource_attribute: attribute, is_required: true, custom_pattern: "The Godfather II")
    json_schema = {
      type: 'object',
      title: "Movie - #{resource_representation.name}",
      description: 'A movie',
      properties: {
        movie: {
          type: 'object',
          properties: {
            main_title: {
              type: 'string',
              description: 'title of the film',
              enum: ["The Godfather", "Finding Nemo"],
              pattern: "The Godfather II"
            }
          },
          required: ["main_title"]
        }
      },
      required: ['movie']
    }
    get resource_resource_representation_path(resource, resource_representation, format: :json_schema, root_key: 'movie')
    assert_equal json_schema.deep_stringify_keys!, JSON.parse(response.body), "json schema is not correct"
  end

  test 'should get json schema associated to resource_representation with reference to other resource_representation in
    attributes_resource_representation' do
    resource = create(:resource, name: 'User', description: 'A user')
    name_attribute = create(:attribute, parent_resource: resource, name: 'name', description: 'name of the user',
     primitive_type: :string)
    manager_attribute = create(:attribute, parent_resource: resource, name: 'manager', description: 'manager of the user',
     resource: resource, primitive_type: nil)
    resource_representation_user = create(:resource_representation, resource: resource, name: 'user')
    resource_representation_manager = create(:resource_representation, resource: resource, name: 'manager')
    create(:attributes_resource_representation, parent_resource_representation: resource_representation_user,
     resource_attribute: name_attribute)
    create(:attributes_resource_representation, parent_resource_representation: resource_representation_user,
     resource_attribute: manager_attribute, resource_representation: resource_representation_manager)
    create(:attributes_resource_representation, parent_resource_representation: resource_representation_manager,
     resource_attribute: name_attribute)
    json_schema = {
      type: 'object',
      title: "User - user",
      description: 'A user',
      properties: {
        user: {
          type: 'object',
          properties: {
            name: { type: 'string', description: 'name of the user'},
            manager: {
              type: 'object',
              description: 'manager of the user',
              title: 'User',
              properties: {
                name: { type: 'string', description: 'name of the user'}
              }
            }
          }
        }
      },
      required: ['user']
    }
    get resource_resource_representation_path(resource, resource_representation_user, format: :json_schema, root_key: 'user')
    assert_equal json_schema.deep_stringify_keys!, JSON.parse(response.body), "json schema is not correct"
  end

  test 'should get json schema associated to resource_representation that is a collection' do
    resource = create(:resource, name: 'Movie', description: 'A movie')
    attribute = create(:attribute, parent_resource: resource, name: 'main_title', description: 'title of the film',
     primitive_type: :string)
    resource_representation = create(:resource_representation, resource: resource)
    create(:attributes_resource_representation, parent_resource_representation: resource_representation,
     resource_attribute: attribute)
    json_schema = {
      type: 'object',
      title: "Movie - #{resource_representation.name}",
      description: 'A movie',
      properties: {
        movies: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              main_title: {
                type: 'string',
                description: 'title of the film'
              }
            }
          }
        }
      },
      required: ['movies']
    }
    get resource_resource_representation_path(resource, resource_representation, format: :json_schema, params: {is_collection: 'true', root_key: 'movies'})
    assert_equal json_schema.deep_stringify_keys!, JSON.parse(response.body), "json schema is not correct"
  end

  test 'should not get root key if not specified' do
    resource = create(:resource, name: 'Movie', description: 'A movie')
    attribute = create(:attribute, parent_resource: resource, name: 'main_title', description: 'title of the film',
     primitive_type: :string, enum: "The Godfather, Finding Nemo", pattern: "The Godfather")
    resource_representation = create(:resource_representation, resource: resource)
    create(:attributes_resource_representation, parent_resource_representation: resource_representation,
     resource_attribute: attribute, is_required: true, custom_pattern: "The Godfather II")
    json_schema = {
      type: 'object',
      title: "Movie - #{resource_representation.name}",
      description: 'A movie',
      properties: {
        main_title: {
          type: 'string',
          description: 'title of the film',
          enum: ["The Godfather", "Finding Nemo"],
          pattern: "The Godfather II"
        }
      },
      required: ["main_title"]
    }
    get resource_resource_representation_path(resource, resource_representation, format: :json_schema)
    assert_equal json_schema.deep_stringify_keys!, JSON.parse(response.body), "json schema is not correct"
  end

  test "should not get json schema associated to resource_representation (not authenticated)" do
    sign_out :user
    resource = create(:resource)
    resource_representation = create(:resource_representation, resource: resource)
    get resource_resource_representation_path(resource, resource_representation, format: :json_schema)
    assert_response :unauthorized
    assert_equal 'You need to sign in or sign up before continuing.', response.body
  end

  private

  def create_representation_hash_with_associations_to_attributes(resource_representation)
    representation_hash = resource_representation.attributes
    associations_to_attributes_hash = {}
    resource_representation.attributes_resource_representations.each_with_index do |association, index|
      associations_to_attributes_hash["#{index}"] = association.attributes.merge!({"_destroy" => "0"})
    end
    representation_hash["attributes_resource_representations_attributes"] = associations_to_attributes_hash
    representation_hash
  end
end
