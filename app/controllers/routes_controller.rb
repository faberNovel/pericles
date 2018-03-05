class RoutesController < ApplicationController
  include ProjectRelated

  lazy_controller_of :route, belongs_to: :project
  decorates_method :route

  def index
    @routes_by_resource = policy_scope(project.routes).includes(:resource, :resource_representations, :responses)
      .group_by(&:resource)
    @resources = @routes_by_resource.keys.sort_by {|r| r.name.downcase}
  end

  def show
  end

  def new
    if project.resources.empty?
      redirect_to project_resources_path(project), alert: t('.resource_required')
    end
  end

  def edit
  end

  def create
    route.request_headers.build(name: 'Authorization')
    route.request_headers.build(name: 'Content-Type', value: 'application/json')
    if route.save
      redirect_to project_route_path(project, route)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if route.update(permitted_attributes(route))
      redirect_to project_route_path(project, route)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    resource = route.resource
    route.destroy

    redirect_to project_resource_path(project, resource)
  end

  private

  def new_route
    project.resources.first.routes.build
  end
end
