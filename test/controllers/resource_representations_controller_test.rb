require 'test_helper'

class ResourceRepresentationsControllerTest < ActionDispatch::IntegrationTest
  test "should show resource_representation" do
    representation = create(:resource_representation)
    get resource_representation_path(representation)
    assert_response :success
  end

  test "should get new" do
    resource = create(:resource)
    get new_resource_resource_representation_path(resource)
    assert_response :success
  end

  test "should get edit" do
    representation = create(:resource_representation_with_attributes_resource_reps)
    get edit_resource_representation_path(representation)
    assert_response :success
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
    assert_redirected_to resource_representation_path(representation)
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
    assert_redirected_to resource_representation_path(representation)
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

  test "should update resource_representation" do
    resource_representation = create(:resource_representation)
    put resource_representation_path(resource_representation), params: { resource_representation:
      { name: 'Modified resource representation' } }
    assert_redirected_to resource_representation_path(resource_representation)
    resource_representation.reload
    assert_equal 'Modified resource representation', resource_representation.name
  end

  test "should not update resource_representation" do
    resource = create(:resource_with_attributes)
    resource_representation = create(:resource_representation, resource: resource)
    name = resource_representation.name
    put resource_representation_path(resource_representation), params: { resource_representation: { name: '' } }
    assert_response :unprocessable_entity
    resource_representation.reload
    assert_equal name, resource_representation.name
  end

  test "should delete resource_representation" do
    resource_representation = create(:resource_representation)
    project = resource_representation.resource.project
    resource = resource_representation.resource
    assert_difference 'ResourceRepresentation.count', -1 do
      delete resource_representation_path(resource_representation)
    end
    assert_redirected_to project_resource_path(project, resource)
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
