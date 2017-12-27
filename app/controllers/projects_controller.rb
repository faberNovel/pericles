require 'zip'

class ProjectsController < AuthenticatedController
  layout 'full_width_column', only: [:show, :edit]
  before_action :setup_project, except: [:index, :new, :create]

  def index
    @projects = policy_scope(Project).all
  end

  def show
    respond_to do |format|
      format.html {}
      format.zip do
        send_data @project.json_schemas_zip_data, type: 'application/zip', filename: "#{@project.title}.zip"
      end
    end
  end

  def new
    @project = Project.new
    authorize @project
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    authorize @project

    if @project.save
      redirect_to @project
    else
      render 'new', status: :unprocessable_entity
    end

  end

  def update
    if @project.update(project_params)
      respond_to do |format|
        format.html {redirect_to @project}
        format.js { render js: 'Turbolinks.clearCache()'}
      end
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy

    redirect_to projects_path
  end

  private

  def setup_project
    @project = Project.find(params[:id])
    authorize @project
  end

  def project_params
    params.require(:project).permit(
      :title,
      :description,
      :proxy_url,
      :mock_profile_id,
    )
  end

end
