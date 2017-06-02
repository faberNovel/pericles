class ResourceRepresentation < ApplicationRecord
  belongs_to :resource, inverse_of: :resource_representations

  validates :name, presence: true, uniqueness: { scope: [:resource], case_sensitive: false }
  validates :resource, presence: true
end
