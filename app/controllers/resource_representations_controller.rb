class ResourceRepresentationsController < ApplicationController
  before_action :setup_resource_representation_and_parent_records, except: [:new, :create]
  before_action :setup_project_and_resource, only: [:new, :create]

  def show
    render layout: 'full_width_column'
  end

  def new
    @representation = @resource.resource_representations.build
    build_missing_attributes_resource_representations(@representation)
    render layout: 'generic'
  end

  def edit
    build_missing_attributes_resource_representations(@representation)
    render layout: 'generic'
  end

  def create
    @representation = @resource.resource_representations.build(resource_rep_params)
    if @representation.save
      redirect_to resource_representation_path(@representation)
    else
      build_missing_attributes_resource_representations(@representation)
      render 'new', layout: 'generic', status: :unprocessable_entity
    end
  end

  private

  def setup_resource_representation_and_parent_records
    @representation = ResourceRepresentation.find(params[:id])
    @resource = @representation.resource
    @project = @resource.project
  end

  def setup_project_and_resource
    @resource = Resource.find(params[:resource_id])
    @project = @resource.project
  end

  def build_missing_attributes_resource_representations(resource_representation)
    @resource.resource_attributes.each do |attribute|
      if resource_representation.attributes_resource_representations
        .select { |attributes_resource_representation | attributes_resource_representation.attribute_id == attribute.id }
        .empty?
        resource_representation.attributes_resource_representations.build(resource_attribute: attribute)
      end
    end
  end

  def resource_rep_params
    params.require(:resource_representation).permit(:name, :description,
      attributes_resource_representations_attributes: [:id, :custom_enum,
        :custom_pattern, :is_required, :attribute_id, :_destroy])
  end
end
