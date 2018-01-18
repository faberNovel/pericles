class ResourceRepresentationSerializer < ActiveModel::Serializer
  attributes :name, :description, :resource_id
  has_many :attributes_resource_representations
end