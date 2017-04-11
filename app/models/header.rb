class Header < ApplicationRecord
  belongs_to :http_message, polymorphic: true

  #FIXME validation passes when two headers with the same name, nested in same http_message
  # are created at the same time
  validates :name, presence: true, uniqueness: { scope: :http_message, case_sensitive: false }
  #FIXME Cannot create headers and the parent http_message at the same time
  validates :http_message, presence: true
end
