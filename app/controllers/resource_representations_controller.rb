class ResourceRepresentationsController < ApplicationController
  include ProjectRelated

  lazy_controller_of :resource_representation, helper_method: true, belongs_to: :resource
  decorates_assigned :all_attributes_resource_representations

  def show
    respond_to do |format|
      format.json_schema do
        render(
          json: resource_representation,
          serializer: ResourceRepresentationSchemaSerializer,
          adapter: :attributes,
          is_collection: ActiveModel::Type::Boolean.new.cast(params[:is_collection]),
          root_key: params[:root_key]
        )
      end
      %i(swift java kotlin).each do |language|
        format.send(language) do
          body = CodeGenerator.new(language)
            .from_resource_representation(resource_representation)
            .generate
          render body: body
        end
      end
    end
  end

  def new
    build_missing_attributes_resource_representations
    render layout: 'generic'
  end

  def edit
    build_missing_attributes_resource_representations
    render layout: 'generic'
  end

  def create
    if resource_representation.save
      redirect_to project_resource_path(project, resource)
    else
      build_missing_attributes_resource_representations
      render 'new', layout: 'generic', status: :unprocessable_entity
    end
  end

  def update
    if resource_representation.update(permitted_attributes(resource_representation))
      respond_to do |format|
        format.html { redirect_to project_resource_path(project, resource) }
        format.json { render json: resource_representation, include: '**', serializer: ExtendedResourceRepresentationSerializer }
      end
    else
      respond_to do |format|
        format.html do
          build_missing_attributes_resource_representations
          render 'edit', layout: 'generic', status: :unprocessable_entity
        end
        format.json { render json: resource_representation.errors }
      end
    end
  end

  def destroy
    begin
      resource_representation.destroy
    rescue ActiveRecord::InvalidForeignKey
      flash[:error] = t('activerecord.errors.models.resource_representation.attributes.base.destroy_failed_foreign_key')
    end

    redirect_to project_resource_path(project, resource)
  end

  def clone
    copy = resource_representation.dup
    copy.name = "#{copy.name} (copy)"
    copy.attributes_resource_representations = resource_representation.attributes_resource_representations.map(&:dup)
    copy.save!

    redirect_to project_resource_path(project, resource)
  end

  private

  def resource
    @resource ||= Resource.find(params[:resource_id])
  end
  helper_method :resource

  def find_project
    resource.project
  end

  def build_missing_attributes_resource_representations
    @all_attributes_resource_representations = resource.resource_attributes.sorted_by_name.map do |attribute|
      resource_representation.attributes_resource_representations.detect do |arr|
        arr.attribute_id == attribute.id
      end || resource_representation.attributes_resource_representations.build(resource_attribute: attribute)
    end
  end
end
