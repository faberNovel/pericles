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
