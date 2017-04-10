class Response < ApplicationRecord
  belongs_to :route, inverse_of: :responses

  has_many :headers, as: :http_message, dependent: :destroy

  validates :status_code, presence: true
  validates :body_schema, json_schema: true, allow_blank: true
  validates :route, presence: true
end
