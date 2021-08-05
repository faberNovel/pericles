require 'simplecov'
SimpleCov.start 'rails'

require 'minitest/reporters'
Minitest::Reporters.use! unless ENV['RM_INFO']
require 'minitest/mock'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'authentication/controller_with_authentication_test.rb'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include FactoryBot::Syntax::Methods

  def assert_not_looping(&block)
    assert Thread.new(&block).join(10)&.value, 'block is looping'
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def validate_json(json_schema_path, json)
    assert_empty JSON::Validator.fully_validate("test/json_schemas#{json_schema_path}.json_schema", json, errors_as_objects: true)
  end

  def validate_json_response_body(json_schema_path)
    validate_json(json_schema_path, response.body)
  end

  def validate_json_request_body(json_schema_path)
    validate_json(json_schema_path, request.request_parameters)
  end
end

require 'spy/integration'
