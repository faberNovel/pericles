class Metadatum < ApplicationRecord
  include HasPrimitiveType

  belongs_to :project, required: true

  has_many :metadata_responses, dependent: :destroy
  has_many :responses, through: :metadata_responses

  validates :name, presence: true, uniqueness: { scope: :project, case_sensitive: true }
  validates :primitive_type, presence: true
end
