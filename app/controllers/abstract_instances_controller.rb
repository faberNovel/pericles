class AbstractInstancesController < AuthenticatedController
  layout 'full_width_column'
  before_action :setup_model_and_project, only: [:new, :create]
  before_action :setup_model_instance, only: [:edit, :update, :destroy]

  def model_name
    raise 'Implement me!'
  end

  def new
    default_body = GenerateJsonInstanceService.new(@model.json_schema).execute
    default_name = "#{@model.name.camelize} #{model_instance_class.all.count + 1}"
    @model_instance = model_instance_class.new({model_name.to_sym => @model, body: default_body, name: default_name})
    authorize @model_instance
  end

  def create
    @model_instance = @model.send("#{model_name}_instances").build(model_instance_params)
    authorize @model_instance
    if @model_instance.save
      redirect_to_model
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @model_instance.update(model_instance_params)
      redirect_to_model
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def destroy
    @model_instance.destroy
    redirect_to_model
  end

  private

  def setup_project
    @project = @model.project
    authorize @project, :show?
  end

  def setup_model_instance
    @model_instance = model_instance_class.find(params[:id])
    authorize @model_instance
    @model = @model_instance.send(model_name)
    setup_project
  end

  def setup_model_and_project
    @model = model_class.find(params["#{model_name}_id".to_sym])
    setup_project
  end

  def redirect_to_model
    redirect_to send("project_#{model_name}_path", @project, @model)
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
end
