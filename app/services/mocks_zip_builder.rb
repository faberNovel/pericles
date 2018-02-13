require 'zip'

class MocksZipBuilder
  def initialize(mock_profile)
    @mock_profile = mock_profile
    @entries = Set.new
  end

  def zip_data
    stringio = Zip::OutputStream.write_buffer do |zio|
      @mock_profile.mock_pickers.preload(:resource_instances).each do |mock_picker|
        entry = filename(mock_picker)

        next if @entries.include? entry
        @entries.add(entry)

        zio.put_next_entry(entry)
        zio.write file_content(mock_picker)
      end
    end
    stringio.rewind
    stringio.sysread
  end

  private

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
