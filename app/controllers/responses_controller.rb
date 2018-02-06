class ResponsesController < ApplicationController
  include ProjectRelated

  layout 'generic'

  # Avoid ApplicationController.response collision
  lazy_controller_of :route_response,
    class_name: 'Response', helper_method: true, belongs_to: :route
  decorates_method :route

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

  def resource
    @resource ||= route.resource
  end
  helper_method :resource

  def find_project
    resource.project
  end
end
