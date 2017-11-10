class MockProfile < ApplicationRecord
  belongs_to :project
  has_many :mock_pickers
  has_many :responses, through: :mock_pickers

  accepts_nested_attributes_for :mock_pickers

  validates :name, presence: true

  def create_missing_pickers
    project.responses.where.not(id: responses.pluck(:id)).find_each do |response|
      MockPicker.create(mock_profile: self, response: response)
    end
  end
end
