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
            is_collection: ActiveModel::Type::Boolean.new.cast(params[:is_collection])
          ).execute
        )
      end
    end
  end

  def new; end

  def edit; end

  def create
    generate_schema_from_json_instance if should_generate_schema_from_json_instance
    if @json_instance_error.blank? && api_error.save
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

  private

  # TODO: Clément Villain 29/03/18: refactor this with ResourcesController
  # Maybe use dry-validation?
  def check_valid_json_object_param(json_string)
    begin
      parsed_json = JSON.parse(json_string)
    rescue JSON::ParserError
      @json_instance_error = 'could not parse JSON'
      return
    end

    @json_instance_error = 'JSON is not an object' unless parsed_json.is_a? Hash
  end

  def should_generate_schema_from_json_instance
    return false if params[:json_instance].blank?

    check_valid_json_object_param(params[:json_instance])
    return false if @json_instance_error

    params[:json_schema].blank?
  end

  def generate_schema_from_json_instance
    params[:api_error][:json_schema] = JSON::SchemaGenerator.generate 'Pericles', params[:json_instance]
  end
end
