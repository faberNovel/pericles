require 'test_helper'

class ResourceRepresentationSchemaSerializerTest < ActiveSupport::TestCase
  attr_accessor :attributes_resource_rep

  def generate_schema(is_collection, root_key)
    self.attributes_resource_rep = build(:attributes_resource_representation)
    representation = build(:resource_representation,
      attributes_resource_representations: [self.attributes_resource_rep, build(:attributes_resource_representation)]
    )
    ResourceRepresentationSchemaSerializer.new(
      representation,
      is_collection: is_collection,
      root_key: root_key
    ).as_json
  end

  test "should produce a valid json schema" do
    meta_schema = 'http://json-schema.org/draft-04/schema#'
    schema = generate_schema(false, 'root_key').to_json
    assert JSON::Validator.fully_validate(meta_schema, schema, json: true).empty?
  end

  test "should be an array if is_collection is set and not root_key" do
    schema = generate_schema(true, '')
    assert_equal 'array', schema[:type]
    assert schema[:items]
  end

  test "should be an object if no is_collection and no root_key" do
    schema = generate_schema(false, '')
    assert_equal 'object', schema[:type]
    assert schema[:properties]
  end

  test "should be an object if is_collection and root_key" do
    schema = generate_schema(true, 'root_key')
    assert_equal 'object', schema[:type]
    assert schema[:properties]
  end

  test "should be an object if no is_collection and root_key" do
    schema = generate_schema(false, 'root_key')
    assert_equal 'object', schema[:type]
    assert schema[:properties]
  end

  test "should use root key" do
    assert generate_schema(false, 'root_key')[:properties]['root_key']
    assert generate_schema(true, 'root_key')[:properties]['root_key']
  end

  test "root key object should be an array if root_key and is_collection" do
    schema = generate_schema(true, 'root_key')
    assert_equal 'array', schema[:properties]['root_key'][:type]
    assert schema[:properties]['root_key'][:items]
  end

  test "root key object should be an object if root_key and no is_collection" do
    schema = generate_schema(false, 'root_key')
    assert_equal 'object', schema[:properties]['root_key'][:type]
    assert schema[:properties]['root_key'][:properties]
  end

  test "should use required if root key" do
    assert_equal ['root_key'], generate_schema(true, 'root_key')[:required]
  end

  test "should not use required if no root key and is_collection" do
    assert_not generate_schema(true, '')[:required]
  end

  test 'attribute name is in properties' do
    assert_includes generate_schema(false, '')[:properties], attributes_resource_rep.resource_attribute.name
  end

  test 'attribute primitive type is set' do
    schema = generate_schema(false, '')
    attribute = attributes_resource_rep.resource_attribute
    assert_equal attribute.primitive_type, schema[:properties][attribute.name][:type]
  end

  test 'schema with nested resources is correct' do
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
              },
              additionalProperties: false
            }
          },
          additionalProperties: false
        }
      },
      additionalProperties: false,
      required: ['user']
    }

    json = ResourceRepresentationSchemaSerializer.new(
      resource_representation_user,
      is_collection: false,
      root_key: 'user'
    ).as_json
    assert_equal json_schema.deep_stringify_keys!, json.deep_stringify_keys!, "json schema is not correct"
  end
end