class SecuritySchemesController < ApplicationController
  include ProjectRelated

  lazy_controller_of :security_scheme, belongs_to: :project
  decorates_method :security_scheme

  def index
    @project = project
  end

  def new; end

  def edit; end

  def create
    if security_scheme.save
      redirect_to project_security_schemes_path(project)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if security_scheme.update(permitted_attributes(security_scheme))
      redirect_to project_security_schemes_path(project)
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    security_scheme.destroy

    redirect_to project_security_schemes_path(project)
  end
end
