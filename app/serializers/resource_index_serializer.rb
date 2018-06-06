class ResourceIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :has_invalid_mocks?
  attributes :request_route_ids
  attributes :response_ids
  has_many :used_resources, serializer: IdSerializer
end
