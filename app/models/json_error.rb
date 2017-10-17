class JsonError < ApplicationRecord
  belongs_to :validation, inverse_of: :json_errors

  validates :description, presence: true
  validates :validation, presence: true
end
