class ValidationSerializer < ActiveModel::Serializer
  attributes :json_schema, :json_instance, :status, :json_errors
end