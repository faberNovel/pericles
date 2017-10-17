require "json-schema"

class ValidationsController < AuthenticatedController
  def index
    @validations = Validation.includes(:json_instance_errors, :json_schema_errors).order("created_at desc").limit(10)
  end

  def new
    @default_json_instance = "{}"
  end

  def create
    permitted_validation_params = validation_params
    schema = permitted_validation_params[:json_schema]
    instance = permitted_validation_params[:json_instance]
    instance_errors = []
    schema_errors = validate_json_schema(schema)
    if schema_errors.empty?
      instance_errors += validate_json_instance(schema, instance)
    end
    validation = Validation.create(json_schema: schema, json_instance: instance)
    schema_errors.each { |error| JsonSchemaError.create(description: error, validation: validation) }
    instance_errors.each { |error| JsonInstanceError.create(description: error, validation: validation) }
    render json: validation, status: :created
  end

  private

  def validation_params
    params.require(:validation).permit(:json_schema, :json_instance)
  end

  def validate_json_schema(schema)
    return validate_json("http://json-schema.org/draft-04/schema#", schema)
  end

  def validate_json_instance(schema, instance)
    return validate_json(schema, instance)
  end

  def validate_json(schema, instance)
    errors = []
    begin
      errors = JSON::Validator.fully_validate(schema, instance, json: true)
    rescue JSON::Schema::JsonParseError, TypeError
      errors << "parse_error"
    end
    errors
  end
end
