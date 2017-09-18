class Response < ApplicationRecord
  belongs_to :route
  belongs_to :resource_representation, inverse_of: :responses

  has_many :headers, inverse_of: :http_message, as: :http_message, dependent: :destroy

  accepts_nested_attributes_for :headers, allow_destroy: true, reject_if: :all_blank

  validates :status_code, presence: true
  validates :body_schema, json_schema: true, allow_blank: true
  validates :route, presence: true

  audited associated_with: :route
end
