class AttributeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :is_array, :primitive_type,
    :resource_id, :enum, :minimum, :maximum, :nullable, :scheme,
    :min_items, :max_items, :readable_type

  has_many :available_resource_representations

  def readable_type
    object.decorate.readable_type
  end

  def available_resource_representations
    object.resource&.resource_representations
  end
end
