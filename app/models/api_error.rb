class ApiError < ApplicationRecord
  belongs_to :project

  # TODO Clément Villain 16/11/17: validate json schema
end
