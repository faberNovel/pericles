require 'test_helper'

module Proxy
  class ReportDecoratorTest < ActiveSupport::TestCase
    setup do
      project = create(:project_with_request)
      report = create(:report, route: project.routes.first, project: project)
      @decorator = Proxy::ReportDecorator.new(report)
    end

    test 'should create no errors for a correct request body' do
      @decorator.request_body = '{"user":"1"}'
      errors = @decorator.errors_for_request_body
      assert_equal 0, errors.length
    end

    test 'invalid JSON in errors for body' do
      @decorator.request_body = '{This is not a valid JSON'
      errors = @decorator.errors_for_request_body
      assert_equal 1, errors.length
      assert_equal 'Body is not a valid JSON', errors.first.description
    end

    test 'body should not be empty' do
      @decorator.request_body = '{}'
      errors = @decorator.errors_for_request_body
      assert_equal 1, errors.length
      assert_includes errors.first.description, 'did not contain a required property of'
    end

    test 'should create an error for a body with additional property' do
      @decorator.request_body = '{"user":"1", "field":"not wanted"}'
      errors = @decorator.errors_for_request_body
      assert_equal 1, errors.length
      assert_includes errors.first.description, 'contains additional properties'
    end
  end
end
