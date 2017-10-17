class Header < ApplicationRecord
  belongs_to :http_message, polymorphic: true

  validates :name, presence: true
  validates :http_message, presence: true

  audited associated_with: :http_message
end
