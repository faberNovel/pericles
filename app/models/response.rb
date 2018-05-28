class Response < ApplicationRecord
  belongs_to :route
  belongs_to :resource_representation, inverse_of: :responses
  belongs_to :api_error

  has_many :headers, inverse_of: :http_message, as: :http_message, dependent: :destroy
  has_many :reports
  has_many :resource_instances, through: :resource_representation
  has_many :api_error_instances, through: :api_error
  has_many :mock_pickers
  has_many :metadata_responses, dependent: :destroy
  has_many :metadata, through: :metadata_responses
  has_many :metadatum_instances, through: :metadata

  delegate :project, to: :route

  accepts_nested_attributes_for :headers, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :metadata_responses, allow_destroy: true

  validates :status_code, presence: true
  validates :route, presence: true
  validates :resource_representation, absence: true, unless: :can_have_resource_representation
  validates :api_error, absence: true, unless: :can_have_api_error

  audited associated_with: :route

  def json_instance
    GenerateJsonInstanceService.new(json_schema).execute if json_schema
  end

  def json_schema
    # TODO: Clément Villain 21/11/17:
    # refactor json schema to use a JSONSchema objet with at least .to_h and .to_json
    # (We could also add .validate(json) and .json_instance)
    JSONSchema::ResponseDecorator.new(self).json_schema
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
