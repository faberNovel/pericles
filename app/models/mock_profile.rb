class MockProfile < ApplicationRecord
  belongs_to :project
  has_many :mock_pickers

  accepts_nested_attributes_for :mock_pickers

  validates :name, presence: true

  def create_missing_pickers
    # FIXME: Clément Villain 10/11/17 performance issue
    project.responses.find_each do |response|
      MockPicker.find_or_create_by(mock_profile: self, response: response)
    end
  end
end
