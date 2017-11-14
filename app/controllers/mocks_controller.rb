class MocksController < ApplicationController

  def compute_mock
    project = Project.find(params[:project_id])
    routes = project.build_route_set
    main_route = routes.recognize_path('/' + params[:path], { method: request.method })
    unless main_route
      render json: {error: 'Route not found'}, status: :not_found
      return
    end

    route = Route.find_by_id(main_route[:name])


    profile = project.active_mock_profile || project.mock_profiles.first

    response = profile&.mock_pickers&.joins(:response)&.find_by(
      responses: {route: route}, response_is_favorite: true
    )&.response

    if response
      mock_picker = profile.mock_pickers.where(response: response).first
      mock_instances = mock_picker&.mock_instances

      if mock_instances&.any?
        mock_body = mock_body_from_instances(mock_instances, response)
      else
        mock_body = random_mock(response)
      end
    else
      response = route.responses.find {|r| r.status_code == 200} || route.responses.first
      mock_body = random_mock(response)
    end

    render json: mock_body, status: response.status_code
  end

  def random_mock(response)
    schema = response.json_schema
    GenerateJsonInstanceService.new(schema).execute
  end

  def mock_body_from_instances(mock_instances, response)
    if response.is_collection
      mock_body = mock_instances.map { |m| m.body_sliced_with(response.resource_representation) }
    else
      mock_body = mock_instances.first.body_sliced_with(response.resource_representation)
    end
    mock_body = {response.root_key => mock_body} unless response.root_key.blank?

    mock_body
  end
end
