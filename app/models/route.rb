class Route < ApplicationRecord
  enum http_method: [:GET, :POST, :PUT, :PATCH, :DELETE]

  has_many :request_headers, as: :http_message, class_name: 'Header', dependent: :destroy
  has_many :request_query_parameters, inverse_of: :route, class_name: 'QueryParameter', dependent: :destroy

  belongs_to :resource, inverse_of: :routes

  accepts_nested_attributes_for :request_query_parameters, allow_destroy: true, reject_if: :all_blank

  validates :name, presence: true, uniqueness: { scope: :resource }
  validates :http_method, presence: true
  validates :url, presence: true
  validates :request_body_schema, json_schema: true, allow_blank: true
  validates :response_schema, json_schema: true, allow_blank: true
  validates :resource, presence: true, uniqueness: { scope: [:http_method, :url]}
end
