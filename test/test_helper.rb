require 'simplecov'
SimpleCov.start 'rails'

require 'minitest/reporters'
Minitest::Reporters.use!
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
end

VCR.configure do |config|
  config.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  config.hook_into :webmock
end
