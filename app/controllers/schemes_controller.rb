class SchemesController < AuthenticatedController
  def index
    @schemes = Scheme.all
  end

  def new
    @scheme = Scheme.new
  end

  def edit
    @scheme = Scheme.find(params[:id])
  end

  def update
    @scheme = Scheme.find(params[:id])

    if @scheme.update(scheme_params)
      redirect_to schemes_path
    else
      render 'edit', status: :unprocessable_entity
    end
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
