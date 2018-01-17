class AbstractInstancesController < ApplicationController
  include ProjectRelated

  layout 'full_width_column'

  def model_name
    raise 'Implement me!'
  end

  def new
  end

  def create
    if model_instance.save
      redirect_to_model
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if model_instance.update(model_instance_params)
      redirect_to_model
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def destroy
    model_instance.destroy
    redirect_to_model
  end

  private

  def find_project
    model.project
  end

  def model
    return @model if defined? @model
    @model = begin
      model = model_class.find(params["#{model_name}_id".to_sym]) if params.has_key? "#{model_name}_id".to_sym
      model || model_instance.send(model_name)
    end

    authorize @model
    @model
  end
  helper_method :model

  def model_instance
    return @model_instance if defined? @model_instance
    @model_instance = begin
      model_instance = model_instance_class.find(params[:id]) if params.has_key? :id
      model_instance ||= model.send("#{model_name}_instances").build(model_instance_params) if params.has_key? "#{model_name}_instance".to_sym
      model_instance || model_instance_class.new({model_name.to_sym => model, body: default_body, name: default_name})
    end

    authorize @model_instance
    @model_instance
  end
  helper_method :model_instance

  def redirect_to_model
    redirect_to send("project_#{model_name}_path", project, model)
  end

  def model_instance_params
    params.require("#{model_name}_instance".to_sym).permit(
      :name,
      :body,
    )
  end

  def model_instance_class
    "#{model_name.camelize}Instance".constantize
  end

  def model_class
    "#{model_name.camelize}".constantize
  end

  def default_body
    GenerateJsonInstanceService.new(model.json_schema).execute
  end

  def default_name
    "#{model.name.camelize} #{model_instance_class.all.count + 1}"
  end
end
