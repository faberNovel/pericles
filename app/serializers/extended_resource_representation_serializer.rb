class ExtendedResourceRepresentationSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :resource_id
  has_many :attributes_resource_representations
end
