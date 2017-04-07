class QueryParameter < ApplicationRecord
  enum primitive_type: [:integer, :string, :boolean]

  belongs_to :route, inverse_of: :request_query_parameters

  validates :name, presence: true, uniqueness: { scope: :route, case_sensitive: false }
  validates :primitive_type, presence: true
  validates :route, presence: true
end
