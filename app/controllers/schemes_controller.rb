class SchemesController < AuthenticatedController
  def index
    @schemes = Scheme.all
  end

  def new
    @scheme = Scheme.new
  end

  def create
    @scheme = Scheme.new(scheme_params)

    if @scheme.save
      redirect_to schemes_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    @scheme = Scheme.find_by(id: params[:id])
    @scheme&.destroy
    redirect_to schemes_path
  end

  private
  def scheme_params
    params.require(:scheme).permit(:name, :regexp)
  end
end
