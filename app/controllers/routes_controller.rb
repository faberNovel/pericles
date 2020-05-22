class RoutesController < ApplicationController
  include ProjectRelated

  lazy_controller_of :route, belongs_to: :project
  decorates_method :route

  def index
    @routes_by_resource = policy_scope(project.routes).includes(:resource, :resource_representations, :responses)
      .map(&:decorate)
      .group_by(&:resource)
    @resources = @routes_by_resource.keys.sort_by { |r| r.name.downcase }
  end

  def show; end

  def new
    redirect_to project_resources_path(project), alert: t('.resource_required') if project.resources.empty?
  end

  def edit; end

  def create
    route.request_headers.build(name: 'Content-Type', value: 'application/json')
    if route.save
      respond_to do |format|
        format.html { redirect_to project_route_path(project, route) }
        format.json { render json: route, status: :created }
      end
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def rest
    url = params[:url]
    resource = policy_scope(Resource).find(params[:resource_id])
    request_representation = policy_scope(ResourceRepresentation).find(params[:request_representation_id])
    response_representation = policy_scope(ResourceRepresentation).find(params[:response_representation_id])

    authorize project.routes.build(resource_id: resource.id)

    CreateRestRoutesTransaction.new.call(
      url: url,
      resource: resource,
      request_resource_representation: request_representation,
      response_resource_representation: response_representation
    ) do |monad|
      monad.success do
        redirect_to project_resource_path(project, resource)
      end

      monad.failure do
        redirect_to project_resource_path(project, resource)
      end
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
    route.destroy

    redirect_to project_routes_path(project)
  end

  private

  def new_route
    project.resources.first.routes.build
  end
end
