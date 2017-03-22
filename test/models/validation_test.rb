require 'test_helper'

class ValidationTest < ActiveSupport::TestCase
  test "Validation should be valid with all attributes set correctly" do
    assert build(:validation, json_schema: '{"type": "string"}', json_instance: '"hello"').valid?
  end
end
