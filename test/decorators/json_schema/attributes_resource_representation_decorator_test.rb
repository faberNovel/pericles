require 'test_helper'

class AttributesResourceRepresentationDecoratorTest < ActiveSupport::TestCase
  setup do
    attribute = create(:attribute, primitive_type: :integer)
    association = create(:attributes_resource_representation,
      resource_attribute: attribute
    )
    @decorator = JSONSchema::AttributesResourceRepresentationDecorator.new(
      association
    )
  end

  test 'nullable property' do
    @decorator.resource_attribute.update(nullable: true)
    assert_equal(
      {
        anyOf: [
          { type: 'integer' },
          { type: 'null' }
        ]
      },
      @decorator.property
    )
  end

  test 'array property' do
    @decorator.resource_attribute.update(
      is_array: true,
      min_items: 123,
      max_items: 456
    )

    assert_equal(
      {
        type: 'array',
        items: { type: 'integer' },
        minItems: 123,
        maxItems: 456
      },
      @decorator.property
    )
  end

  test 'enum string is correctly cast' do
    @decorator.resource_attribute.update(enum: '1.1, 2.2')
    assert_equal [1, 2], @decorator.property[:enum]

    @decorator.resource_attribute.update(primitive_type: :number)
    assert_equal [1.1, 2.2], @decorator.property[:enum]

    @decorator.resource_attribute.update(primitive_type: :string)
    assert_equal ['1.1', '2.2'], @decorator.property[:enum]

    @decorator.resource_attribute.update(primitive_type: :null)
    assert_equal [nil], @decorator.property[:enum]
  end

  test 'ref another resource property ' do
    referenced_resource = create(:resource)
    referenced_rep = referenced_resource.default_representation
    @decorator.resource_attribute.update(
      primitive_type: nil, resource: referenced_resource
    )
    @decorator.reload

    assert_equal(
      {
        type: 'object',
        '$ref': "#/definitions/#{referenced_rep.name}_#{referenced_rep.id}"
      },
      @decorator.property
    )
  end
end
