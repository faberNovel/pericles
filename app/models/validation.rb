class Validation < ApplicationRecord
  has_many :json_errors, inverse_of: :validation, dependent: :destroy
  has_many :json_instance_errors
  has_many :json_schema_errors

  def status
    if json_schema_errors.any?
      return json_schema_errors.first.description == "parse_error" ? :schema_parse_error : :schema_validation_error
    end
    if json_instance_errors.any?
      return json_instance_errors.first.description == "parse_error" ? :instance_parse_error : :instance_validation_error
    end
    return :success
  end
end
