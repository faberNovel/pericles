class Header < ApplicationRecord
  belongs_to :http_message, polymorphic: true

  validates :name, presence: true, uniqueness: { scope: :http_message, case_sensitive: false }
  validates :http_message, presence: true
end
