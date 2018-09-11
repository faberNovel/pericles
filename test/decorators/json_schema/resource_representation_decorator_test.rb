require 'test_helper'

class ResourceRepresentationDecoratorTest < ActiveSupport::TestCase
  test 'json schema is not looping' do
    user = create(:resource)
    representation = user.resource_representations.first
    managee = create(:attribute, parent_resource: user, resource: user, name: 'managee', primitive_type: nil)
    create(
      :attributes_resource_representation,
      resource_attribute: managee,
      parent_resource_representation: representation,
      resource_representation: representation
    )

    assert_not_looping { JSONSchema::ResourceRepresentationDecorator.new(representation.reload).json_schema }
  end
end
