class AttributesResourceRepresentation < ApplicationRecord
  belongs_to :parent_resource_representation, inverse_of: :attributes_resource_representations,
   class_name: "ResourceRepresentation"
  belongs_to :resource_attribute, inverse_of: :attributes_resource_representations, class_name: "Attribute",
   foreign_key: "attribute_id"
  belongs_to :resource_representation
  belongs_to :faker

  scope :ordered_by_attribute_name, -> { joins(:resource_attribute).order('attributes.name') }

  validates :parent_resource_representation, presence: true
  validates :resource_attribute, presence: true, uniqueness: { scope: [:parent_resource_representation] }
  validates :custom_enum, absence: true, unless: :attribute_is_enumerable?
  validates :custom_pattern, absence: true, unless: "resource_attribute.string?"
  validates :resource_representation, presence: true, if: "resource_attribute.resource"

  private

  def attribute_is_enumerable?
    resource_attribute.primitive_type && !resource_attribute.boolean?
  end
end
