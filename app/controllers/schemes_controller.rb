class SchemesController < ApplicationController

  def index
    @schemes = policy_scope(Scheme).all
  end

  def new
    @scheme = Scheme.new
    authorize @scheme
  end

  def edit
    @scheme = Scheme.find(params[:id])
    authorize @scheme
  end

  def update
    @scheme = Scheme.find(params[:id])
    authorize @scheme

    if @scheme.update(scheme_params)
      redirect_to schemes_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def create
    @scheme = Scheme.new(scheme_params)
    authorize @scheme

    if @scheme.save
      redirect_to schemes_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    @scheme = Scheme.find_by(id: params[:id])
    authorize @scheme
    @scheme&.destroy
    redirect_to schemes_path
  end

  private
  def scheme_params
    params.require(:scheme).permit(:name, :regexp)
  end
end
