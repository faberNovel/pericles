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

  test 'mock_body returns an empty array if collection and no instances' do
    mock_picker = create(:mock_picker, response: create(:response, is_collection: true))
    assert_equal [], mock_picker.mock_body
  end

  test 'mock_body returns an array of random instances if collection and no instances' do
    mock_picker = create(
      :mock_picker,
      instances_number: 10,
      response: create(:response, is_collection: true, resource_representation: create(:resource_representation))
    )
    assert_equal 10, mock_picker.mock_body.count
  end

  test 'mock_body returns an empty array if instances number is negative' do
    mock_picker = create(
      :mock_picker,
      instances_number: -1,
      response: create(:response, is_collection: true, resource_representation: create(:resource_representation))
    )
    assert_equal [], mock_picker.mock_body
  end

  test 'mock_body returns a hash if no collection' do
    mock_picker = create(
      :mock_picker,
      instances_number: 10,
      response: create(:response, is_collection: false, resource_representation: create(:resource_representation))
    )
    assert_equal Hash, mock_picker.mock_body.class
  end

  test 'mock_body returns an array of instances and random instances if collection' do
    mock_picker = create(
      :mock_picker,
      instances_number: 10,
      response: create(:response, is_collection: true, resource_representation: create(:resource_representation))
    )
    mock_picker.resource_instances << create_list(:resource_instance, 5)
    assert_equal 10, mock_picker.mock_body.count
  end
end
