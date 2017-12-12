class MockProfile < ApplicationRecord
  belongs_to :project
  has_many :mock_pickers
  has_many :responses, through: :mock_pickers
  has_ancestry

  accepts_nested_attributes_for :mock_pickers, allow_destroy: true

  validates :name, presence: true

  def inherited_and_self_mock_pickers_of(route)
    sorted_profiles = (ancestors.ordered_by_ancestry.to_a << self).reverse
    # Note: Clément Villain 12/12/17 sorted_profiles is a very short list (<30 items max) so there is not that many n+1 queries
    # Feel free to fix it !
    sorted_profiles.map { |profile| profile.mock_pickers.joins(:response).where(responses: { route: route }) }.flatten
  end
end
