class RoutesController < ApplicationController
  include ProjectRelated

  lazy_controller_of :route, belongs_to: :project
  decorates_method :route

  def index
    @routes_by_resource = policy_scope(project.routes).includes(:resource, :resource_representations, :responses)
      .group_by(&:resource)
    @resources = @routes_by_resource.keys.sort_by {|r| r.name.downcase}
    render layout: 'full_width_column'
  end

  def show
    render layout: 'generic'
  end

  def new
    if project.resources.empty?
      redirect_to project_resources_path(project), alert: t('.resource_required')
    else
      render layout: 'generic'
    end
  end

  def edit
    render layout: 'generic'
  end

  def create
    route.request_headers.build(name: 'Authorization')
    route.request_headers.build(name: 'Content-Type', value: 'application/json')
    if route.save
      redirect_to project_route_path(project, route)
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def update
    if route.update(permitted_attributes(route))
      redirect_to project_route_path(project, route)
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def destroy
    resource = route.resource
    route.destroy

    redirect_to project_resource_path(project, resource)
  end
end
