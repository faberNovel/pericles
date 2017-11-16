class ApiError < ApplicationRecord
  belongs_to :project

  has_many :api_error_instances

  # TODO Clément Villain 16/11/17: validate json schema
end
