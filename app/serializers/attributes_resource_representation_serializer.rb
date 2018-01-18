class AttributesResourceRepresentationSerializer < ActiveModel::Serializer
  attributes :id, :is_required, :parent_resource_representation_id, :attribute_id, :resource_representation_id, :custom_key_name, :is_null
end