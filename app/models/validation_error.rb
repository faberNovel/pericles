class ValidationError < ApplicationRecord
  belongs_to :report

  enum category: [:header, :body, :status_code]

  validates :description, presence: true

  def header_name
    return unless header?

    description.split.first
  end
end
