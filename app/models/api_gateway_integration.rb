class ApiGatewayIntegration < ApplicationRecord
  belongs_to :project

  validates :title, presence: false
  validates :uri_prefix, presence: false
  validates :timeout_in_millis, presence: false
end
