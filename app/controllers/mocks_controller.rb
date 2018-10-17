class MocksController < ApplicationController
  def compute_mock
    expires_now

    @project = Project.find(params[:project_id])
    routes = @project.build_route_set
    main_route = routes.recognize_path(request_url, { method: request.method })
    return render json: { error: 'Route not found' }, status: :not_found unless main_route

    route = Route.find_by(id: main_route[:name])
    mock_picker = find_matching_mock_picker(route)
    response = find_response(mock_picker, route)
    return render json: { error: 'Response not found' }, status: :not_found unless response

    render json: build_body(mock_picker, response), status: response.status_code
  end

  def find_mock_profile
    @project.active_mock_profile || @project.mock_profiles.first
  end

  private

  def build_body(mock_picker, response)
    if mock_picker
      mock_picker.mock_body
    else
      random_mock(response)
    end
  end

  def find_response(mock_picker, route)
    mock_picker&.response || route.responses.find { |r| r.status_code == 200 } || route.responses.first
  end

  def find_matching_mock_picker(route)
    mock_profile = find_mock_profile
    mock_pickers_of_route = mock_profile&.inherited_and_self_mock_pickers_of(route)
    body = request.body.read
    mock_pickers_of_route.detect do |picker|
      picker.match(request_url, body)
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
