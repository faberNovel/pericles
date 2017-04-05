class Project < ApplicationRecord
  has_many :resources, inverse_of: :project, dependent: :destroy

  validates :title, presence: true, length: { in: 2..25 }, uniqueness: true
  validates :description, length: { maximum: 500 }
end
