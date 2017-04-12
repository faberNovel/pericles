class Header < ApplicationRecord
  belongs_to :http_message, polymorphic: true

  #FIXME validation passes when two headers with the same name, nested in same http_message
  # are created at the same time
  validates :name, presence: true, uniqueness: { scope: :http_message, case_sensitive: false }
  validates :http_message, presence: true
end
