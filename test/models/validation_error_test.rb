require 'test_helper'

class ValidationErrorTest < ActiveSupport::TestCase
  test 'header name is the first word of description' do
    validation_error = build(:validation_error,
      category: :header,
      description: 'Content-Type is missing from the response headers'
    )

    assert_equal 'Content-Type', validation_error.header_name
  end
end
