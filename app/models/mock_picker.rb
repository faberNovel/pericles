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
    return GenerateJsonInstanceService.new(response.json_schema).execute unless mock_instances.any?

    if response.is_collection
      body = mock_instances.map(&:as_json)
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
end
