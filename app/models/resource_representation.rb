class ResourceRepresentation < ApplicationRecord
  belongs_to :resource, inverse_of: :resource_representations

  has_many :attributes_resource_representations, inverse_of: :resource_representation, dependent: :destroy
  has_many :resource_attributes, through: :attributes_resource_representations

  validates :name, presence: true, uniqueness: { scope: [:resource], case_sensitive: false }
  validates :resource, presence: true
end
