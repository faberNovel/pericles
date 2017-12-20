class MocksController < ApplicationController

  def compute_mock
    @project = Project.find(params[:project_id])
    routes = @project.build_route_set
    main_route = routes.recognize_path(request_url, { method: request.method })
    unless main_route
      render json: {error: 'Route not found'}, status: :not_found
      return
    end

    route = Route.find_by_id(main_route[:name])
    profile = pick_profile
    mock_picker = find_matching_mock_picker(profile, route)
    response = mock_picker&.response || route.responses.find {|r| r.status_code == 200} || route.responses.first

    if mock_picker
      mock_body = mock_picker.mock_body
    else
      mock_body = random_mock(response)
    end

    render json: mock_body, status: response.status_code
  end

  def pick_profile
    @project.active_mock_profile || @project.mock_profiles.first
  end

  private

  def find_matching_mock_picker(mock_profile, route)
    mock_pickers_of_route = mock_profile&.inherited_and_self_mock_pickers_of(route)
    mock_pickers_of_route.detect do |picker|
      picker.match(request_url, request.body.read)
    end
  end

  def request_url
    '/' + (request.url.split('mocks/')[-1] || '')
  end

  def random_mock(response)
    schema = response.json_schema
    GenerateJsonInstanceService.new(schema).execute
  end
end
