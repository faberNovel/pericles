class MockProfilesController < MocksController
  include ProjectRelated

  layout 'full_width_column'
  lazy_controller_of :mock_profile, helper_method: true

  def index
    @mock_profiles = project.mock_profiles
  end

  def new
  end

  def create
    if mock_profile.save
      redirect_to_mock_profile
    else
      render 'new', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if mock_profile.update(permitted_attributes(mock_profile))
      redirect_to_mock_profile
    else
      render 'edit', layout: 'full_width_column', status: :unprocessable_entity
    end
  end

  private

  def find_project
    # With find_mock_profile we avoid authorization process that create an infinite loop
    super || find_mock_profile.project
  end

  def build_mock_profile_from_params
    project.mock_profiles.new(permitted_attributes(MockProfile)) if params.has_key? :mock_profile
  end

  def new_mock_profile
    project.mock_profiles.new
  end

  def mock_pickers_by_response_id
    @mock_pickers_by_response_id ||= mock_profile.mock_pickers.includes(:resource_instances, :api_error_instances).group_by(&:response_id)
  end
  helper_method :mock_pickers_by_response_id

  def redirect_to_mock_profile
    redirect_to edit_mock_profile_path(mock_profile)
  end
end
