class Scheme < ApplicationRecord
  validates :name, presence: true

  has_many :resource_attributes, class_name: 'Attribute', dependent: :nullify
end
