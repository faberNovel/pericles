class MockProfilesController < MocksController
  include ProjectRelated

  layout 'full_width_column'
  before_action :setup_mock_profile, only: [:edit, :update]

  def index
    @mock_profiles = project.mock_profiles
  end

  def new
    @mock_profile = project.mock_profiles.new
  end

  def create
    @mock_profile = project.mock_profiles.new(mock_profile_params)
    if @mock_profile.save
      redirect_to_mock_profile
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @mock_profile.update(mock_profile_params)
      redirect_to_mock_profile
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def pick_profile
    MockProfile.find(params[:mock_profile_id])
  end

  private

  def setup_mock_profile
    @mock_profile = MockProfile.includes(:mock_pickers).find(params[:id])
    authorize @mock_profile
    @mock_pickers_by_response_id = @mock_profile.mock_pickers.includes(:resource_instances, :api_error_instances).group_by(&:response_id)
    @project = @mock_profile.project
  end

  def mock_profile_params
    params.require(:mock_profile).permit(
      :name,
      :parent_id,
      mock_pickers_attributes: [
        :id,
        :body_pattern,
        :url_pattern,
        :resource_instance_ids,
        :api_error_instance_ids,
        :response_id,
        :_destroy,
        resource_instance_ids: [],
        api_error_instance_ids: [],
      ]
    )
  end

  def redirect_to_mock_profile
    redirect_to edit_mock_profile_path(@mock_profile)
  end
end
