require 'test_helper'

class CreateRestRoutesTransactionTest < ActiveSupport::TestCase
  setup do
    @project = create(:project)
    @resource = create(:resource, project: @project)
  end

  test 'create 5 routes and 5 responses' do
    assert_difference 'Route.count', 5 do
      assert_difference 'Response.count', 5 do
        CreateRestRoutesTransaction.new.call(
          url: '/route',
          resource: @resource,
          request_resource_representation: create(:resource_representation, resource: @resource),
          response_resource_representation: create(:resource_representation, resource: @resource)
        )
      end
    end
  end
end
