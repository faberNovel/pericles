require 'test_helper'

class BodyErrorViewModelFactoryTest < ActiveSupport::TestCase
  setup do
    @factory = BodyError::ViewModelFactory.new
  end

  test 'additional properties' do
    original_description = "The property '#/products/0' contains additional properties [\"price_FR1_2017\", \"currency_FR1_2017\"] outside of the schema when none are allowed in schema 532dcc88-39f9-5fe0-a10f-a45e6d960d25"
    vm = @factory.build(original_description)

    assert_equal :additional, vm.type
    assert_equal 'products', vm.readable_path
    assert_equal 'products/0 - additional properties "price_FR1_2017", "currency_FR1_2017"', vm.description
  end

  test 'required property' do
    original_description = "The property '#/products/0' did not contain a required property of 'isInStock' in schema 532dcc88-39f9-5fe0-a10f-a45e6d960d25"
    vm = @factory.build(original_description)

    assert_equal :required, vm.type
    assert_equal 'products', vm.readable_path
    assert_equal "products/0 - missing property 'isInStock'", vm.description
  end

  test 'wrong type' do
    original_description = "The property '#/products/0' of type string did not match the following type: object in schema 532dcc88-39f9-5fe0-a10f-a45e6d960d25"
    vm = @factory.build(original_description)

    assert_equal :type, vm.type
    assert_equal 'products', vm.readable_path
    assert_equal 'products/0 - wrong type: string instead of object', vm.description
  end

  test 'non null type' do
    original_description = "The property '#/products/0' of type null did not match the following type: object in schema 532dcc88-39f9-5fe0-a10f-a45e6d960d25"
    vm = @factory.build(original_description)

    assert_equal :type, vm.type
    assert_equal 'products', vm.readable_path
    assert_equal 'products/0 - cannot be null', vm.description
  end

  test 'unknown error' do
    original_description = 'Never gonna give you up'
    vm = @factory.build(original_description)

    assert_equal :unknown, vm.type
    assert_nil vm.readable_path
    assert_equal original_description, vm.description
  end
end
