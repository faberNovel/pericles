class ResourceRepresentationSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :resource_id
end