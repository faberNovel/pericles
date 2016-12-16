class JsonSchemasController < ApplicationController
  layout 'show_project'
  before_action :setup_project, only: [:new, :create]

  def new
    @json_schema = @project.json_schemas.build
  end

  def create
    @json_schema = @project.json_schemas.build(json_schema_params)
    if @json_schema.save
      #FIXME when show is done
      # redirect_to @json_schema
    else
      render 'new'
    end
  end

  private

  def setup_project
    @project = Project.find(params[:project_id])
  end

  def json_schema_params
    params.require(:json_schema).permit(:name, :schema)
  end

end
