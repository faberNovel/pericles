require 'test_helper'

class JsonErrorTest < ActiveSupport::TestCase
  test "shouldn't exist without a description" do
    assert_not build(:json_error, description: nil).valid?
  end

  test "shouldn't exist without a validation" do
    assert_not build(:json_error, validation: nil).valid?
  end
end
