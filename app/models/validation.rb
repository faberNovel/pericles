class Validation < ApplicationRecord
  has_many :json_errors, inverse_of: :validation, dependent: :destroy
  has_many :json_instance_errors
  has_many :json_schema_errors
end
