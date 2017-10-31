require 'simplecov'
SimpleCov.start 'rails'

require "minitest/reporters"
Minitest::Reporters.use!

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include FactoryGirl::Syntax::Methods
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end
