require 'test_helper'

class ResourceRepresentationsControllerTest < ControllerWithAuthenticationTest
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

    assert_redirected_to project_resource_path(resource.project, resource)
  end

  test "should create resource_representation with attributes_resource_representations" do
    resource_representation = build(:resource_representation_with_attributes_resource_reps)
    res_rep_params_hash = create_representation_hash_with_associations_to_attributes(resource_representation)
    resource = resource_representation.resource
    count = resource_representation.attributes_resource_representations.length
    assert_not count.zero?

    assert_difference('AttributesResourceRepresentation.count', count) do
      post resource_resource_representations_path(resource), params: { resource_representation: res_rep_params_hash }
    end

    assert_redirected_to project_resource_path(resource.project, resource)
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
    assert_redirected_to project_resource_path(resource.project, resource)
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
    project = resource_representation.resource.project
    resource = resource_representation.resource
    route = create(:route, resource: resource)
    create(:response, route: route, resource_representation: resource_representation)
    assert_no_difference('ResourceRepresentation.count') do
      delete resource_resource_representation_path(resource, resource_representation)
    end
    assert_redirected_to project_resource_path(project, resource)
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
     primitive_type: :string, enum: "The Godfather, Finding Nemo", scheme: create(:scheme, regexp: "The Godfather II"))
    resource_representation = create(:resource_representation, resource: resource)
    create(:attributes_resource_representation, parent_resource_representation: resource_representation,
     resource_attribute: attribute, is_required: true)
    json_schema = ResourceRepresentationSchemaSerializer.new(
      resource_representation,
      is_collection: false,
      root_key: 'movie'
    ).as_json

    get resource_resource_representation_path(resource, resource_representation, format: :json_schema, root_key: 'movie')
    assert_equal json_schema.deep_stringify_keys!, JSON.parse(response.body), "json schema is not correct"
  end

  test "should not get json schema associated to resource_representation (not authenticated)" do
    sign_out :user
    resource = create(:resource)
    resource_representation = create(:resource_representation, resource: resource)
    get resource_resource_representation_path(resource, resource_representation, format: :json_schema)

    assert_redirected_to new_user_session_path
  end

  test "clone should create new resource_representation" do
    resource = create(:resource_with_attributes)
    resource_representation = resource.default_representation
    assert_difference 'ResourceRepresentation.count' do
      post resource_resource_representation_clone_path(resource, resource_representation)
    end
  end

  test "clone should create new attributes_resource_representation" do
    resource = create(:resource_with_attributes)
    resource_representation = resource.default_representation
    attribute = resource.resource_attributes.first
    resource_representation.attributes_resource_representations = [
      create(:attributes_resource_representation, resource_attribute: attribute, resource_representation: attribute&.resource&.default_representation)
    ]

    assert_difference 'AttributesResourceRepresentation.count' do
      post resource_resource_representation_clone_path(resource, resource_representation)
    end
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
