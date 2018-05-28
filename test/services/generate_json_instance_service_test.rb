require 'test_helper'

class GenerateJsonInstanceServiceTest < ActiveSupport::TestCase
  test 'should generate date' do
    json = GenerateJsonInstanceService.new({ type: 'string', format: 'date' }).execute
    begin
      date = Date.parse(json)
    rescue ArgumentError
      date = nil
    end
    assert date
  end

  test 'should generate datetime' do
    json = GenerateJsonInstanceService.new({ type: 'string', format: 'datetime' }).execute
    begin
      date = DateTime.parse(json)
    rescue ArgumentError
      date = nil
    end
    assert date
  end

  test 'should generate empty body if json_schema is nil' do
    assert_equal '', GenerateJsonInstanceService.new(nil).execute
  end
end
