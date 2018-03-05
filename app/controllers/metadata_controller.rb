class MetadataController < ApplicationController
  include ProjectRelated

  lazy_controller_of :metadatum, belongs_to: :project, helper_method: true

  def index
    @metadata = project.metadata
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if metadatum.save
      redirect_to project_metadata_path(project)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if metadatum.update(permitted_attributes(metadatum))
      redirect_to project_metadata_path(project)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    metadatum.destroy

    redirect_to project_metadata_path(project)
  end

  private

  def find_project
    super || find_metadatum.project
  end

  def available_types
    return @available_types if defined? @available_types

    @available_types = Metadatum.primitive_types.keys.to_a.map { |k| [k.capitalize, k] }
  end
  helper_method :available_types
end
