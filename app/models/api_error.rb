class ApiError < ApplicationRecord
  belongs_to :project

  has_many :api_error_instances

  validates :name, presence: true
  validates :json_schema, json_schema: true

  def has_invalid_mocks?
    api_error_instances.any? { |mock| !mock.valid? }
  end
end
