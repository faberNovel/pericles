class ResourceIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :has_invalid_mocks?
  has_many :used_resources, serializer: IdSerializer
end