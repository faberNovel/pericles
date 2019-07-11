class ExtendedResourceRepresentationSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :resource_id, :used_in_resource_representations

  has_many :attributes_resource_representations

  def used_in_resource_representations
    object.used_in_resource_representations.pluck(:name)
  end
end
