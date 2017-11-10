class MockPicker < ApplicationRecord
  belongs_to :mock_profile
  belongs_to :response

  has_and_belongs_to_many :mock_instances

  validates_uniqueness_of :mock_profile_id, scope: [:response_id]

  # TODO: Clément Villain 10/11/17 is favorite must be unique if responses share the same route
end
