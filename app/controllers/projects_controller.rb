class ProjectsController < ApplicationController

	before_action :setup_project, except: [:index, :new, :create]
	layout "show_project", only: [:show]

  def index
    @projects = Project.all
  end

	def show
		select_hash = {"desc" => ["Description", @project.description]}
		tag = params[:tag]
		@section_title = tag ? select_hash[tag][0] : nil
		@content = tag ? select_hash[tag][1] : nil
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
      render 'new'
    end

  end

	def update
		if @project.update(project_params)
			redirect_to @project
		else
			render 'edit'
		end
	end

  private

  def setup_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:title, :description)
  end

end
