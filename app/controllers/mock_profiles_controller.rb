class MockProfilesController < MocksController
  include ProjectRelated

  lazy_controller_of :mock_profile, helper_method: true, belongs_to: :project

  def show
    respond_to do |format|
      format.zip do
        send_data(
          MocksZipBuilder.new(mock_profile).zip_data,
          type: 'application/zip',
          filename: "#{project.title}.mocks.zip"
        )
      end
    end
  end

  def index
    @mock_profiles = project.mock_profiles
  end

  def new
  end

  def create
    if mock_profile.save
      redirect_to_mock_profile
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if mock_profile.update(permitted_attributes(mock_profile))
      redirect_to_mock_profile
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    new_active = project.mock_profiles.where.not(
      id: mock_profile.id
    ).first
    project.update(mock_profile_id: new_active&.id)

    mock_profile.destroy

    redirect_to project_mock_profiles_path(project)
  end

  private

  def find_project
    # With find_mock_profile we avoid authorization process that create an infinite loop
    super || find_mock_profile.project
  end

  def mock_pickers_by_response_id
    @mock_pickers_by_response_id ||= mock_profile.mock_pickers.includes(:resource_instances, :api_error_instances).group_by(&:response_id)
  end
  helper_method :mock_pickers_by_response_id

  def redirect_to_mock_profile
    redirect_to edit_mock_profile_path(mock_profile)
  end
end
