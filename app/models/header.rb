class Header < ApplicationRecord
  belongs_to :http_message, polymorphic: true
  belongs_to :response, foreign_key: 'http_message_id', optional: true
  belongs_to :route, foreign_key: 'http_message_id', optional: true

  validates :name, presence: true
  validates :http_message, presence: true

  audited associated_with: :http_message

  delegate :project, to: :http_message
end
