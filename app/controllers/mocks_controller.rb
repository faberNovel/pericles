class MocksController < ApplicationController

  def compute_mock
    routes = Project.find(params[:project_id]).build_route_set
    main_route = routes.recognize_path('/' + params[:path], { method: request.method })
    if main_route
      route = Route.find_by_id(main_route[:name])
      response = route.responses.first
      status_code = response.status_code
      if response.resource_representation.mock_instances
        # TODO: Clément Villain 9/11/17
        mock_body = {}
      else
        schema = response.json_schema
        mock_body = GenerateJsonInstanceService.new(schema).execute
      end
      render json: mock_body, status: status_code
    else
      render json: {error: 'Route not found'}, status: :not_found
    end
  end

end
