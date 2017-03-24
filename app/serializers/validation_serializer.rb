class ValidationSerializer < ActiveModel::Serializer
  attributes :json_schema, :json_instance, :status

  has_many :json_errors
end