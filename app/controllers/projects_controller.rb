require 'zip'

class ProjectsController < AuthenticatedController
  layout 'full_width_column', only: [:show, :edit]
  before_action :setup_project, except: [:index, :new, :create]

  def index
    @projects = Project.all
  end

  def show
    respond_to do |format|
      format.html
      format.zip do
        compressed_filestream = Zip::OutputStream.write_buffer do |zos|
          @project.resources.each do |resource|
            zos.put_next_entry "includes/_#{resource.name.downcase}.md"
            zos.print ResourcesController.render :show, assigns: { resource: resource }, formats: :md
          end
          zos.put_next_entry "index.md"
          zos.print ResourcesController.render :index, assigns: { project: @project, resources: @project.resources }, formats: :md
        end
        compressed_filestream.rewind
        send_data compressed_filestream.read, filename: "#{@project.title.downcase}.zip"
      end
    end
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project
    else
      render 'new', status: :unprocessable_entity
    end

  end

  def update
    if @project.update(project_params)
      redirect_to @project
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
  end

  def project_params
    params.require(:project).permit(:title, :description, :server_url)
  end

end
