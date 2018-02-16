class ProxyConfiguration < ApplicationRecord
  belongs_to :project, required: true

  # TODO Clément Villain 16/02/18
  # validates url
  validates :target_base_url, presence: true
end