class AttributesResourceRepresentation < ApplicationRecord
  belongs_to :resource_representation, inverse_of: :attributes_resource_representations
  belongs_to :resource_attribute, inverse_of: :attributes_resource_representations, class_name: "Attribute", foreign_key: "attribute_id"

  validates :resource_representation, presence: true
  validates :resource_attribute, presence: true, uniqueness: { scope: [:resource_representation] }
  #TODO (Charles-Elie SIMON - 05/06/17) Add validations on enum and pattern attributes
end
