class ResourceRepresentationsController < ApplicationController
  before_action :setup_resource_representation, only: [:show]

  def show
    setup_project_and_resource(@representation)
    render layout: 'full_width_column'
  end

  private

  def setup_resource_representation
    @representation = ResourceRepresentation.find(params[:id])
  end

  def setup_project_and_resource(resource_representation)
    @resource = resource_representation.resource
    @project = @resource.project
  end
end
