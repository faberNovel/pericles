class AttributesResourceRepresentation < ApplicationRecord
  belongs_to :parent_resource_representation, inverse_of: :attributes_resource_representations,
                                              class_name: 'ResourceRepresentation'
  belongs_to :resource_attribute, inverse_of: :attributes_resource_representations, class_name: 'Attribute',
                                  foreign_key: 'attribute_id'
  belongs_to :resource_representation

  scope :ordered_by_attribute_name, -> { joins(:resource_attribute).order('attributes.name') }

  validates :parent_resource_representation, presence: true
  validates :resource_attribute, presence: true, uniqueness: { scope: [:parent_resource_representation] }
  validates :resource_representation, presence: true, if: -> { resource_attribute.resource }

  audited associated_with: :parent_resource_representation

  def key_name
    custom_key_name.presence || resource_attribute.default_key_name
  end

  private

  def attribute_is_enumerable?
    resource_attribute.primitive_type && !resource_attribute.boolean?
  end
end
