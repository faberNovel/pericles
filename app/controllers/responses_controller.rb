class ResponsesController < ApplicationController
  include ProjectRelated

  layout 'generic'

  def new
    route_response.headers.build(name: 'Authorization')
    route_response.headers.build(name: 'Content-Type', value: 'application/json')
  end

  def edit
  end

  def create
    if route_response.save
      redirect_to project_route_path(project, route)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if route_response.update(response_params)
      redirect_to project_route_path(project, route)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    route_response.destroy

    redirect_to project_route_path(project, route)
  end

  private

  def route
    @route ||= Route.find(params[:route_id])
  end
  helper_method :route

  def resource
    @resource ||= route.resource
  end
  helper_method :resource

  def find_project
    resource.project
  end

  # Avoid ApplicationController.response collision
  def route_response
    return @response if defined? @response
    @response = begin
      response = route.responses.find(params[:id]) if params.has_key? :id
      response ||= route.responses.build(response_params) if params.has_key? :response
      response || route.responses.build
    end
    authorize @response
    @response
  end
  helper_method :route_response

  def response_params
    params.require(:response).permit(
      :status_code,
      :resource_representation_id,
      :api_error_id,
      :is_collection,
      :root_key,
      headers_attributes: [:id, :name, :value, :_destroy]
    )
  end
end
