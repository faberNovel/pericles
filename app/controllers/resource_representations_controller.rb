class ResourceRepresentationsController < AuthenticatedController
  before_action :setup_project_and_resource, except: [:index]
  before_action :setup_resource_representation, except: [:index, :new, :create]
  decorates_assigned :all_attributes_resource_representations

  def show
    respond_to do |format|
      format.json_schema do
        render(
          json: @representation,
          serializer: ResourceRepresentationSchemaSerializer,
          adapter: :attributes,
          is_collection: ActiveModel::Type::Boolean.new.cast(params[:is_collection]),
          root_key: params[:root_key]
        )
      end
      %i(swift java kotlin).each do |language|
        format.send(language) do
          render body: CodeGenerator.new(language).from_resource_representation(@representation).generate
        end
      end
    end

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
      redirect_to project_resource_path(@project, @resource)
    else
      build_missing_attributes_resource_representations(@representation)
      render 'new', layout: 'generic', status: :unprocessable_entity
    end
  end

  def update
    if @representation.update(resource_rep_params)
      redirect_to project_resource_path(@project, @resource)
    else
      build_missing_attributes_resource_representations(@representation)
      render 'edit', layout: 'generic', status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @representation.destroy
    rescue ActiveRecord::InvalidForeignKey
      flash[:error] = t('activerecord.errors.models.resource_representation.attributes.base.destroy_failed_foreign_key')
    end

    redirect_to project_resource_path(@project, @resource)
  end

  def clone
    copy = @representation.dup
    copy.name = "#{copy.name} (copy)"
    copy.attributes_resource_representations = @representation.attributes_resource_representations.map(&:dup)
    copy.save!

    redirect_to project_resource_path(@project, @resource)
  end

  private

  def setup_project_and_resource
    @resource = Resource.find(params[:resource_id])
    @project = @resource.project
  end

  def setup_resource_representation
    @representation = ResourceRepresentation.find(params[:id] || params[:resource_representation_id])
  end

  def build_missing_attributes_resource_representations(resource_representation)
    @all_attributes_resource_representations = @resource.resource_attributes.sorted_by_name.map do |attribute|
      resource_representation.attributes_resource_representations.detect do |arr|
        arr.attribute_id == attribute.id
      end || resource_representation.attributes_resource_representations.build(resource_attribute: attribute)
    end
  end

  def resource_rep_params
    params.require(:resource_representation).permit(
      :name,
      :description,
      attributes_resource_representations_attributes: [
        :id,
        :resource_representation_id,
        :custom_key_name,
        :is_required,
        :is_null,
        :attribute_id,
        :_destroy
      ]
    )
  end
end
