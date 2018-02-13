class MetadatumInstance < ApplicationRecord
  include Instance

  belongs_to :metadatum
  delegate :project, to: :metadatum

  def parent
    metadatum
  end
end
