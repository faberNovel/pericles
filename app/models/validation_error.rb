class ValidationError < ApplicationRecord
  belongs_to :report

  enum category: [:header, :body, :status_code]

  validates :description, presence: true
end
