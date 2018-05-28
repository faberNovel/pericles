class ValidationsController < ApplicationController
  def index
    @validations = Validation.order(created_at: 'desc').page(params[:page]).per(10)
  end

  def new
    @default_json_instance = '{}'
  end

  def create
    validation = Validation.create(validation_params)
    render json: validation, status: :created
  end

  private

  def validation_params
    params.require(:validation).permit(:json_schema, :json_instance)
  end
end
