class Response < ApplicationRecord
  belongs_to :route
  belongs_to :resource_representation, inverse_of: :responses
  belongs_to :api_error

  has_many :headers, inverse_of: :http_message, as: :http_message, dependent: :destroy
  has_many :reports
  has_many :resource_instances, through: :resource_representation
  has_many :api_error_instances, through: :api_error
  has_many :mock_pickers

  accepts_nested_attributes_for :headers, allow_destroy: true, reject_if: :all_blank

  validates :status_code, presence: true
  validates :route, presence: true

  audited associated_with: :route

  validates :resource_representation, absence: true, unless: :can_have_resource_representation
  validates :api_error, absence: true, unless: :can_have_api_error

  def errors_from_http_response(http_response)
    errors_for_status(http_response) +
    errors_for_headers(http_response) +
    errors_for_body(http_response)
  end

  def errors_for_status(http_response)
    self.status_code == http_response.status.code ? [] :
    [
      ValidationError.new(
        category: :status_code,
        description: "Status code is #{http_response.status.code} instead of #{self.status_code}"
      )
    ]
  end

  def errors_for_headers(http_response)
    self.headers.map do |h|
       ValidationError.new(
        category: :header,
        description: "#{h.name} is missing from the response headers"
      ) unless http_response.headers.to_h.key? h.name
    end.compact
  end

  def errors_for_body(http_response)
    JSON::Validator.fully_validate(
      json_schema, http_response.body, json: true
    ).map do |error_message|
      ValidationError.new(
        category: :body,
        description: error_message
      )
    end
  end

  def json_instance
    GenerateJsonInstanceService.new(json_schema).execute if json_schema
  end

  def json_schema
    # TODO Clément Villain 21/11/17:
    # refactor json schema to use a JSONSchema objet with at least .to_h and .to_json
    # (We could also add .validate(json) and .json_instance)
    if resource_representation
      ResourceRepresentationSchemaSerializer.new(
        resource_representation,
        is_collection: is_collection,
        root_key: root_key
      ).as_json
    elsif api_error
      JSONSchemaWrapper.new(
        api_error.json_schema,
        root_key,
        is_collection,
      ).execute
    end
  end

  def can_have_api_error
    status_code && status_code >= 400
  end

  def can_have_resource_representation
    status_code && !can_have_api_error
  end

  def representation
    api_error || resource_representation
  end
end
