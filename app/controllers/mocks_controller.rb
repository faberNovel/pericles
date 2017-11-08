class MocksController < ApplicationController

  def compute_mock
    routes = Project.find(params[:project_id]).build_route_set
    main_route = routes.recognize_path('/' + params[:path], { method: request.method })
    if main_route
      route = Route.find_by_id(main_route[:name])
      if route.active_mock
        mock_body = route.active_mock.body
        status_code = route.active_mock.response.status_code
      else
        response = route.responses.first
        schema = response.json_schema
        status_code = response.status_code
        mock_body = GenerateJsonInstanceService.new(schema).execute
      end
      render json: mock_body, status: status_code
    else
      render json: {error: 'Route not found'}, status: :not_found
    end
  end

end
