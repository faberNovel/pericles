require 'test_helper'

class SliceJSONWithResourceRepresentationTest < ActiveSupport::TestCase
  setup do
    @representation = create(:resource_representation)
    attribute = create(:attribute, parent_resource: @representation.resource, name: 'id', primitive_type: :string)
    create(:attributes_resource_representation, parent_resource_representation: @representation, resource_attribute: attribute)
  end

  test "should remove unselected keys" do
    json = SliceJSONWithResourceRepresentation.new({id: 1, name: "John Doe"}, @representation).execute
    assert_equal({id: 1}, json)
  end
  test "should use representation overided key name" do
    @representation.attributes_resource_representations.first.update(custom_key_name: 'key')
    json = SliceJSONWithResourceRepresentation.new({id: 1, name: "John Doe", key: 'value'}, @representation).execute
    assert_equal({key: 'value'}, json)
  end
end
