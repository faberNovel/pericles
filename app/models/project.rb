class Project < ApplicationRecord
  has_many :json_schemas, dependent: :destroy

  validates :title, presence: true, length: { in: 2..25 }, uniqueness: true
  validates :description, length: { maximum: 500 }
end
