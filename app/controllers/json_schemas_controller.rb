class JsonSchemasController < ApplicationController
  layout 'show_project'
  before_action :setup_project, only: [:index, :new, :create]
  before_action :setup_project_and_json_schema, except: [:index, :new, :create]

  def index
    @json_schemas = @project.json_schemas
  end

  def show
  end

  def new
    @json_schema = @project.json_schemas.build
  end

  def edit
  end

  def create
    @json_schema = @project.json_schemas.build(json_schema_params)
    if @json_schema.save
      redirect_to project_json_schema_path(@project, @json_schema)
    else
      render 'new'
    end
  end

  def update
    if @json_schema.update(json_schema_params)
      redirect_to project_json_schema_path(@project, @json_schema)
    else
      render 'edit'
    end
  end

  def destroy
    @json_schema.destroy

    redirect_to project_json_schemas_path(@project)
  end

  private

  def setup_project
    @project = Project.includes(:json_schemas).find(params[:project_id])
  end

  def setup_project_and_json_schema
    setup_project
    @json_schema = @project.json_schemas.find(params[:id])
  end

  def json_schema_params
    params.require(:json_schema).permit(:name, :schema)
  end

end
