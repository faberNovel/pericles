class ResponsesController < ApplicationController
  include ProjectRelated

  layout 'generic'

  # Avoid ApplicationController.response collision
  lazy_controller_of :route_response, class_name: 'Response', helper_method: true

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
    if route_response.update(permitted_attributes(Response))
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

  def find_route_response
    route.responses.find(params[:id]) if params.has_key? :id
  end

  def build_route_response_from_params
    route.responses.build(permitted_attributes(Response)) if params.has_key? :response
  end

  def new_route_response
    route.responses.build
  end
end
