require 'test_helper'

module Proxy
  class ResponseDecoratorTest < ActiveSupport::TestCase
    setup do
      resource_representation = create(:resource_representation)
      response = create(:response, resource_representation: resource_representation)
      @decorator = Proxy::ResponseDecorator.new(response)
    end

    test 'invalid JSON in errors for body' do
      errors = @decorator.errors_for_body('<div>This is not JSON')
      assert_equal 1, errors.length
      assert_equal 'Body is not a valid JSON', errors.first.description
    end
  end
end
