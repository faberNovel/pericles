require 'zip'

class MocksZipBuilder < AbstractZipBuilder
  def initialize(mock_profile)
    @mock_profile = mock_profile
  end

  def collection
    @mock_profile.mock_pickers.preload(:resource_instances)
  end

  def filename(mock_picker)
    if mock_picker.url_pattern.blank?
      filename = mock_picker.response.route.url
    else
      filename = mock_picker.url_pattern
    end
    filename_without_trailing_slashes = filename.gsub(/(^\/+)|(\/+$)/, '')
    filename_without_trailing_slashes + '.json'
  end

  def file_content(mock_picker)
    JSON.stable_pretty_generate(mock_picker.mock_body)
  end
end
