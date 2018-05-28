require 'test_helper'

class MockPickerTest < ActiveSupport::TestCase
  test 'body pattern must be a valid regexp' do
    assert_not build(:mock_picker, body_pattern: '[[').valid?
    assert build(:mock_picker, body_pattern: '[123]').valid?
  end

  test 'url pattern must be a valid regexp' do
    assert_not build(:mock_picker, url_pattern: '[[').valid?
    assert build(:mock_picker, url_pattern: '[123]').valid?
  end

  test 'url regexp returns a regexp' do
    assert build(:mock_picker, url_pattern: '[123]').url_regexp.is_a? Regexp
  end

  test 'body regexp returns a regexp' do
    assert build(:mock_picker, body_pattern: '[123]').body_regexp.is_a? Regexp
  end
end
