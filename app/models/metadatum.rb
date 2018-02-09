class Metadatum < ApplicationRecord
  include HasPrimitiveType

  belongs_to :project, required: true

  has_many :metadata_responses, dependent: :destroy
  has_many :responses, through: :metadata_responses
  has_many :metadatum_instances

  validates :name, presence: true, uniqueness: { scope: :project, case_sensitive: true }
  validates :primitive_type, presence: true

  def json_schema
    type = (datetime? || date?) ? :string : primitive_type
    { type: type }
  end
end
