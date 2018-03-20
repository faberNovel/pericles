class ApiErrorsController < ApplicationController
  include ProjectRelated

  lazy_controller_of :api_error, helper_method: true, belongs_to: :project

  def index
    @api_errors = project.api_errors.sort_by { |api_error| api_error.name.downcase }
  end

  def show
    respond_to do |format|
      format.html
      format.json_schema do
        render(
          json: JSONSchemaBuilder.new(
            api_error,
            root_key: params[:root_key],
            is_collection: ActiveModel::Type::Boolean.new.cast(params[:is_collection]),
          ).execute
        )
      end
    end
  end

  def new
  end

  def edit
  end

  def create
    if api_error.save
      redirect_to project_api_error_path(project, api_error)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if api_error.update(permitted_attributes(api_error))
      redirect_to project_api_error_path(project, api_error)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    api_error.destroy
    redirect_to project_api_errors_path(project)
  end
end