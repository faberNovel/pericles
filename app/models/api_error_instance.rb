class ApiErrorInstance < ApplicationRecord
  belongs_to :api_error

  has_and_belongs_to_many :mock_pickers

  # TODO Clément Villain 16/11/17: validate body with json schema
end
