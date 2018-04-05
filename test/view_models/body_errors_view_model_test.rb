require 'test_helper'

class BodyErrorViewModelTest < ActiveSupport::TestCase
  test 'empty list' do
    bevm = BodyErrorsViewModel.new
    assert_equal 0, bevm.count
  end

  test 'test act as a list properties' do
    vm1 = BodyErrorViewModel.new(
      "The property '#/products/0' did not contain a required property of 'isInStock' in schema 532dcc88-39f9-5fe0-a10f-a45e6d960d25"
    )
    vm2 = BodyErrorViewModel.new(
      "The property '#/products/0' of type string did not match the following type: object in schema 532dcc88-39f9-5fe0-a10f-a45e6d960d25"
    )

    bevm = BodyErrorsViewModel.new(vm1, vm2)
    assert_equal Set.new(bevm.each), Set.new([vm1, vm2])
  end

  test 'group required properties by path' do
    vm1 = BodyErrorViewModel.new(
      "The property '#/products/0' did not contain a required property of 'isInStock' in schema 532dcc88-39f9-5fe0-a10f-a45e6d960d25"
    )
    vm2 = BodyErrorViewModel.new(
      "The property '#/products/0' did not contain a required property of 'notInStock' in schema 532dcc88-39f9-5fe0-a10f-a45e6d960d25"
    )
    vm3 = BodyErrorViewModel.new(
      "The property '#/products/1' did not contain a required property of 'isInStock' in schema 532dcc88-39f9-5fe0-a10f-a45e6d960d25"
    )

    bevm = BodyErrorsViewModel.new(vm1, vm2, vm3)
    wanted_descriptions = [
      "products/0 - missing properties 'isInStock', 'notInStock'",
      "products/1 - missing property 'isInStock'"
    ]
    assert_equal 2, bevm.count
    assert_equal wanted_descriptions, bevm.map(&:description)
  end
end

