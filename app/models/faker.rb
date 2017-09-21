class Faker < ApplicationRecord
  has_many :attributes_resource_representations

  validates :name, presence: true
end
