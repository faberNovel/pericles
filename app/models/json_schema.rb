class JsonSchema < ApplicationRecord
  belongs_to :project

  validates :name, presence: true, :uniqueness => {:scope => [:project]}
  validates :schema, presence: true
  validates :project, presence: true
end
