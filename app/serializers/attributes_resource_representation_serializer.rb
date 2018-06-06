class AttributesResourceRepresentationSerializer < ActiveModel::Serializer
  attributes :id, :is_required, :parent_resource_representation_id,
    :attribute_id, :resource_representation_id, :custom_key_name, :is_null,
    :resource_representation_name

  def resource_representation_name
    object.resource_representation&.name
  end
end
