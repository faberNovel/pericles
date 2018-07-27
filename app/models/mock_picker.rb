class MockPicker < ApplicationRecord
  belongs_to :mock_profile
  belongs_to :response

  has_and_belongs_to_many :resource_instances
  has_and_belongs_to_many :api_error_instances
  has_and_belongs_to_many :metadatum_instances

  validates :body_pattern, regexp: true, allow_blank: true
  validates :url_pattern, regexp: true, allow_blank: true

  def match(url, body)
    (body_pattern.blank? || body_regexp.match(body)) && (url_pattern.blank? || url_regexp.match(url))
  end

  def body_regexp
    Regexp.new(body_pattern) if body_pattern.present?
  end

  def url_regexp
    Regexp.new(url_pattern) if url_pattern.present?
  end

  def mock_instances
    resource_instances.to_a + api_error_instances.to_a
  end

  def mock_body
    if mock_instances.empty? && !response.is_collection
      return GenerateJsonInstanceService.new(response.json_schema).execute
    end

    if response.is_collection
      body = collection_body
    else
      body = mock_instances.first.as_json
    end
    body = { response.root_key => body } if response.root_key.present?

    if body.is_a? Hash
      metadatum_instances.each do |m|
        body[m.metadatum.name] = m.body.as_json
      end
    end

    body
  end

  private

  def collection_body
    body = mock_instances.map(&:as_json)
    return body if instances_number.nil?
    return [] if instances_number.negative?

    if mock_instances.count >= instances_number
      body = body.slice(0, instances_number)
    else
      instances_number_to_generate = instances_number - mock_instances.count
      body += (0...instances_number_to_generate).map { |_| GenerateJsonInstanceService.new(response.resource_representation.json_schema).execute }
    end

    body
  end
end
