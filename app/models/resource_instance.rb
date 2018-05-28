class ResourceInstance < ApplicationRecord
  include Instance

  belongs_to :resource

  delegate :project, to: :resource

  def parent
    resource
  end
end
