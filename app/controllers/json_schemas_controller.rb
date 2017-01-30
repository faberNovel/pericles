class JsonSchemasController < ApplicationController
  layout 'show_project'
  before_action :setup_project

  def show
    @json_schema = @project.json_schemas.find(params[:id])
  end

  def new
    @json_schema = @project.json_schemas.build
  end

  def create
    @json_schema = @project.json_schemas.build(json_schema_params)
    if @json_schema.save
      redirect_to project_json_schema_path(@project, @json_schema)
    else
      render 'new'
    end
  end

  private

  def setup_project
    @project = Project.includes(:json_schemas).find(params[:project_id])
  end

  def json_schema_params
    params.require(:json_schema).permit(:name, :schema)
  end

end
