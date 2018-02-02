class ResourceSerializer < ActiveModel::Serializer
  attributes :id, :name, :description
  has_many :resource_attributes
  has_many :resource_representations, serializer: ExtendedResourceRepresentationSerializer
end