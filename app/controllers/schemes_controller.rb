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

  private
  def scheme_params
    params.require(:scheme).permit(:name, :regexp)
  end
end
