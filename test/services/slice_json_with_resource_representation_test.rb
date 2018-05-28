require 'test_helper'

class SliceJSONWithResourceRepresentationTest < ActiveSupport::TestCase
  setup do
    @representation = create(:resource_representation)
    attribute = create(:attribute, parent_resource: @representation.resource, name: 'id', primitive_type: :string)
    create(:attributes_resource_representation, parent_resource_representation: @representation, resource_attribute: attribute)
  end

  test 'should remove unselected keys' do
    json = SliceJSONWithResourceRepresentation.new({ id: 1, name: 'John Doe' }, @representation).execute
    assert_equal({ id: 1 }, json)
  end

  test 'should use representation overided key name' do
    @representation.attributes_resource_representations.first.update(custom_key_name: 'key')
    json = SliceJSONWithResourceRepresentation.new({ id: 1, name: 'John Doe', key: 'value' }, @representation).execute
    assert_equal({ key: 'value' }, json)
  end

  test 'should use null value if is_null' do
    @representation.attributes_resource_representations.update(is_null: true)
    json = SliceJSONWithResourceRepresentation.new({ id: 1 }, @representation).execute
    assert_equal({ id: nil }, json)
  end

  test 'should slice nested rep' do
    parent = create(:resource_representation)
    attribute = create(:attribute,
      parent_resource: parent.resource,
      name: 'child',
      resource: @representation.resource,
      primitive_type: nil
    )
    create(:attributes_resource_representation,
      parent_resource_representation: parent,
      resource_attribute: attribute,
      resource_representation: @representation
    )

    json = SliceJSONWithResourceRepresentation.new({ child: { id: 1, name: 'John Doe' } }, parent.reload).execute
    assert_equal({ child: { id: 1 } }, json)
  end

  test 'should slice nested rep array' do
    parent = create(:resource_representation)
    attribute = create(:attribute,
      parent_resource: parent.resource,
      name: 'child',
      resource: @representation.resource,
      primitive_type: nil,
      is_array: true
    )
    create(:attributes_resource_representation,
      parent_resource_representation: parent,
      resource_attribute: attribute,
      resource_representation: @representation
    )

    json = SliceJSONWithResourceRepresentation.new({ child: [{ id: 1, name: 'John Doe' }] }, parent.reload).execute
    assert_equal({ child: [{ id: 1 }] }, json)
  end
end
