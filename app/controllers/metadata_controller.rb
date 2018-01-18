class MetadataController < ApplicationController
  include ProjectRelated
  layout 'full_width_column'

  def index
    @metadata = project.metadata
  end
end
