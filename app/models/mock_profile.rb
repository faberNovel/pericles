class MockProfile < ApplicationRecord
  belongs_to :project
  has_many :mock_pickers
  has_many :responses, through: :mock_pickers
  has_ancestry

  accepts_nested_attributes_for :mock_pickers, allow_destroy: true

  validates :name, presence: true
end
