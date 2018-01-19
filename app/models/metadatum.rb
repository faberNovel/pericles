class Metadatum < ApplicationRecord
  include HasPrimitiveType

  belongs_to :project

  validates :name, presence: true, uniqueness: { scope: :project, case_sensitive: true }
  validates :primitive_type, presence: true
  validates :project, presence: true
end
