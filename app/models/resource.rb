class Resource < ApplicationRecord
  belongs_to :project, inverse_of: :resources

  validates :name, presence: true, uniqueness: { scope: :project, case_sensitive: false }
  validates :project, presence: true
end
