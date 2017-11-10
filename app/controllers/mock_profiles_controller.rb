class MockProfilesController < AuthenticatedController
  layout 'full_width_column'
  before_action :setup_mock_profile, only: [:edit, :update]

  def edit
  end

  def update
    if @mock_profile.update(mock_profile_params)
      redirect_to_mock_profile
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  private

  def setup_mock_profile
    @mock_profile = MockProfile.includes(:mock_pickers).find(params[:id])
    @mock_profile.create_missing_pickers
    @project = @mock_profile.project
  end

  def mock_profile_params
    params.require(:mock_profile).permit(
      :name,
      mock_pickers_attributes: [
        :id,
        mock_instance_ids: [],
      ]
    )
  end

  def redirect_to_mock_profile
    redirect_to edit_mock_profile_path(@mock_profile)
  end
end
