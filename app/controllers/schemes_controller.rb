class SchemesController < ApplicationController
  lazy_controller_of :scheme, helper_method: true

  def index
    @schemes = policy_scope(Scheme).all
  end

  def new; end

  def edit; end

  def update
    if scheme.update(permitted_attributes(scheme))
      redirect_to schemes_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    if scheme.save
      redirect_to schemes_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    scheme.destroy
    redirect_to schemes_path
  end
end
