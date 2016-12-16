class Project < ApplicationRecord
  has_many :json_schemas, dependent: :destroy
  validates :title, presence: true, length: { in: 2..25 }
  validates :description, length: { maximum: 500 }
end
