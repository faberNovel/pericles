require 'test_helper'

class QueryParameterTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:query_parameter, name: nil).valid?
  end

  test "shouldn't exist without a primitive_type" do
    assert_not build(:query_parameter, primitive_type: nil).valid?
  end

  test "shouldn't exist without a route" do
    assert_not build(:query_parameter, route: nil).valid?
  end

  test "QueryParameter should be valid with all attributes set correctly" do
    assert build(:query_parameter, name: "user_id", description: "New test QueryParameter", primitive_type: :string, is_optional: false).valid?
  end
end
