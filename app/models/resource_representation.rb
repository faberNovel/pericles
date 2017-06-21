class ResourceRepresentation < ApplicationRecord
  belongs_to :resource, inverse_of: :resource_representations

  has_many :attributes_resource_representations, inverse_of: :parent_resource_representation,
   foreign_key: "parent_resource_representation_id", dependent: :destroy
  has_many :resource_attributes, through: :attributes_resource_representations
  has_many :responses, inverse_of: :resource_representation

  accepts_nested_attributes_for :attributes_resource_representations, allow_destroy: true

  validates :name, presence: true, uniqueness: { scope: [:resource], case_sensitive: false }
  validates :resource, presence: true
end
