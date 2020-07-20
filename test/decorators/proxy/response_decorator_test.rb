require 'test_helper'

module Proxy
  class ResponseDecoratorTest < ActiveSupport::TestCase
    setup do
      project = create(:project_with_response)
      @decorator = Proxy::ResponseDecorator.new(project.responses.first)
    end

    test 'invalid JSON in errors for body' do
      errors = @decorator.errors_for_body('<div>This is not JSON')
      assert_equal 1, errors.length
      assert_equal 'Body is not a valid JSON', errors.first.description
    end

    test 'correct response body should create no errors' do
      errors = @decorator.errors_for_body('{"user":"1"}')
      assert_equal 0, errors.length
    end

    test 'body should not be empty' do
      errors = @decorator.errors_for_body('{}')
      assert_equal 1, errors.length
      assert_includes errors.first.description, 'did not contain a required property of'
    end

    test 'should create an error for a body with additional property' do
      errors = @decorator.errors_for_body('{"user":"1", "field":"not wanted"}')
      assert_equal 1, errors.length
      assert_includes errors.first.description, 'contains additional properties'
    end
  end
end
