class ResourceRepresentationsController < ApplicationController
  before_action :setup_resource_representation_and_parent_records, only: [:show]
  before_action :setup_project_and_resource, except: [:index, :show]
  before_action :setup_resource_representation, except: [:index, :show, :new, :create]

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

  def update
    if @representation.update(resource_rep_params)
      redirect_to resource_representation_path(@representation)
    else
      build_missing_attributes_resource_representations(@representation)
      render 'edit', layout: 'generic', status: :unprocessable_entity
    end
  end

  def destroy
    @representation.destroy

    redirect_to project_resource_path(@project, @resource)
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

  def setup_resource_representation
    @representation = ResourceRepresentation.find(params[:id])
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
