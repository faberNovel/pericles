return unless Rails.groups.map(&:to_sym).include? :development

require 'yaml'
require 'net/http'
require 'zip'
require 'fileutils'


namespace :pericles do
  desc "Load all json schema in test json schemas folder"
  task schemas: :environment do
    config = YAML.load_file('.pericles.yml')
    project_id = config['project_id']
    session = config['session']

    url = URI.parse("https://ad-pericles.herokuapp.com/projects/#{project_id}.json_schema")
    request = Net::HTTP::Get.new(url, {'Cookie': "_Pericles_GW_gw_session=#{session}"})
    zip_data = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      http.request request
    end

    # Heroku closed the connection
    exit 1 if zip_data.body.length <= 506

    Zip::InputStream.open(StringIO.new(zip_data.body)) do |io|
      while (entry = io.get_next_entry)
        folders = entry.to_s.split('/')[0...-1].join('/')
        FileUtils.mkdir_p "test/json_schemas/#{folders}"
        IO.binwrite("test/json_schemas/#{entry}", io.read)
      end
    end
  end
end
