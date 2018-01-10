class ApiErrorsController < ApplicationController
  include Authenticated
  include ProjectRelated

  layout 'full_width_column'

  def index
    @api_errors = project.api_errors.sort_by { |api_error| api_error.name.downcase }
  end

  def show
    @api_error = ApiError.find(params[:id])

    respond_to do |format|
      format.html
      format.json_schema do
        render(
          json: JSONSchemaWrapper.new(
            @api_error.json_schema,
            params[:root_key],
            ActiveModel::Type::Boolean.new.cast(params[:is_collection]),
          ).execute
        )
      end
    end
  end

  def new
    @api_error = project.api_errors.build
  end

  def edit
    @api_error = ApiError.find(params[:id])
  end

  def create
    @api_error = project.api_errors.build(api_error_params)
    if @api_error.save
      redirect_to project_api_error_path(project, @api_error)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    @api_error = ApiError.find(params[:id])
    if @api_error.update(api_error_params)
      redirect_to project_api_error_path(project, @api_error)
    else
      @selectable_api_errors = project.api_errors.to_a
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @api_error = ApiError.find(params[:id])
    @api_error.destroy
    redirect_to project_api_errors_path(project)
  end

  private

  def api_error_params
    params.require(:api_error).permit(
      :name,
      :json_schema
    )
  end
end