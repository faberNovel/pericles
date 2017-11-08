class MocksController < ApplicationController

  def compute_mock
    routes = Project.find(params[:project_id]).build_route_set
    main_route = routes.recognize_path('/' + params[:path], { method: request.method })
    if main_route
      route = Route.find_by_id(main_route[:name])
      if route.active_mock
        mock_body = route.active_mock.body
      else
        schema = route.responses.first.json_schema
        mock_body = GenerateJsonInstanceService.new(schema).execute
      end
      render json: mock_body
    else
      render json: {error: 'Route not found'}, status: :not_found
    end
  end

end
