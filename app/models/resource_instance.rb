class ResourceInstance < ApplicationRecord
  include Instance

  belongs_to :resource

  def parent
    resource
  end

  def body_sliced_with(resource_representation)
    SliceJSONWithResourceRepresentation.new(JSON.parse(body), resource_representation).execute
  end
end
