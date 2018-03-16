class ProjectsController < ApplicationController
  lazy_controller_of :project
  decorates_method :project

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
      format.swagger do
        send_data(
          Swagger::ProjectDecorator.new(project).to_swagger,
          filename: "#{project.title}.json"
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
    project.build_proxy_configuration unless project.proxy_configuration
  end

  def create
    if project.save
      redirect_to project
    else
      render 'new', status: :unprocessable_entity
    end

  end

  def update
    params = permitted_attributes(project)

    set_proxy_to_be_destroyed_if_blank(params)

    if project.update(params)
      redirect_to project
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    project.destroy

    redirect_to projects_path
  end

  def search
    @results = SearchService.new(project).search(params[:query])
  end

  private

  def set_proxy_to_be_destroyed_if_blank(params)
    if params.dig(:proxy_configuration_attributes, :target_base_url).blank?
      params[:proxy_configuration_attributes] = {
        id: project.proxy_configuration&.id,
        _destroy: true
      }
    end
  end
end
