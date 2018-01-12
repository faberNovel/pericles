class ProjectsController < ApplicationController
  layout 'full_width_column', only: [:show, :edit]
  lazy_controller_of :project
  lazy_decorates_assigned :project

  def index
    @projects = policy_scope(Project).all.order("lower(title)")
  end

  def show
    respond_to do |format|
      format.html {}
      format.json_schema do
        send_data(
          project.json_schemas_zip_data,
          type: 'application/zip',
          filename: "#{project.title}.json_schema.zip"
        )
      end
      %i(swift java kotlin).each do |language|
        format.send(language) do
          send_data(
            CodeZipBuilder.new(project, language).zip_data,
            type: 'application/zip',
            filename: "#{project.title}.#{language}.zip"
          )
        end
      end
    end
  end

  def new
  end

  def edit
  end

  def create
    if project.save
      redirect_to project
    else
      render 'new', status: :unprocessable_entity
    end

  end

  def update
    if project.update(permitted_attributes(project))
      redirect_to project
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def destroy
    project.destroy

    redirect_to projects_path
  end
end
