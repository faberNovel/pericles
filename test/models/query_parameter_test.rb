require 'test_helper'

class QueryParameterTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:query_parameter, name: nil).valid?
  end

  test "Two query_parameters within the same route shouldn't have the same name" do
    query_parameter = create(:query_parameter)
    name = query_parameter.name
    route = query_parameter.route
    assert_not build(:query_parameter, name: name, route: route).valid?
    assert_not build(:query_parameter, name: name.upcase, route: route).valid?
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
