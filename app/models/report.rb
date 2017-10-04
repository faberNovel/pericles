class Report < ApplicationRecord
  belongs_to :route

  validates :status_code, :body, :headers, presence: true
end
