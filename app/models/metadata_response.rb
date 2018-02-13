class MetadataResponse < ApplicationRecord
  belongs_to :metadatum, required: true
  belongs_to :response, required: true

  validates_uniqueness_of :metadatum_id, scope: :response_id
end