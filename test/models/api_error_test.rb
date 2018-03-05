require 'test_helper'

class AttributeTest < ActiveSupport::TestCase
  test "must have a valid json schema" do
    assert_not build(:api_error, json_schema: '').valid?
    assert_not build(:api_error, json_schema: '{{').valid?
    assert_not build(:api_error, json_schema: '{"id": 1}').valid?

    assert build(:api_error, json_schema: '{}').valid?
  end
end
