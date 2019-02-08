require 'test_helper'

class AttributeTest < ActiveSupport::TestCase
  test 'must have a valid json schema' do
    assert_not build(:api_error, json_schema: '').valid?
    assert_not build(:api_error, json_schema: '{{').valid?
    assert_not build(:api_error, json_schema: '{"id": 1}').valid?

    assert build(:api_error, json_schema: '{}').valid?
  end

  test 'destroy should delete instances' do
    api_error_instance = create(:api_error_instance)

    assert_difference 'ApiErrorInstance.count', -1 do
      api_error_instance.api_error.destroy
    end
  end
end
