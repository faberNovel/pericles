class Metadatum < ApplicationRecord
  enum primitive_type: [:integer, :string, :boolean, :number]

  belongs_to :project

  validates :name, presence: true, uniqueness: { scope: :project, case_sensitive: true }
  validates :primitive_type, presence: true
  validates :project, presence: true
end
