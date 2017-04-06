class Response < ApplicationRecord
  validates :status_code, presence: true
  validates :body_schema, json_schema: true, allow_blank: true
end
