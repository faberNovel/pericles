require 'test_helper'

class MocksZipBuilderTest < ActiveSupport::TestCase
  setup do
    @route = create(:route, url: '/path/to/file')
    @response = create(:response, route: @route, resource_representation: create(:resource_representation))
    @mock_profile = create(:mock_profile)
    @mock_picker = create(:mock_picker, mock_profile: @mock_profile, response: @response)
  end

  test 'test filename is based on route url' do
    zip_data = MocksZipBuilder.new(@mock_profile.reload).zip_data
    Zip::InputStream.open(StringIO.new(zip_data)) do |io|
      entry = io.get_next_entry
      assert_equal entry.to_s, 'path/to/file.json'
    end
  end

  test 'test filename is based on url pattern if not blank' do
    @mock_picker.update(url_pattern: '/path/to/file/1')
    zip_data = MocksZipBuilder.new(@mock_profile.reload).zip_data
    Zip::InputStream.open(StringIO.new(zip_data)) do |io|
      entry = io.get_next_entry
      assert_equal entry.to_s, 'path/to/file/1.json'
    end
  end
end
