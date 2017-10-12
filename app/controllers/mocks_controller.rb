class MocksController < ApplicationController

  def compute_mock
    routes = Project.find(params[:project_id]).build_route_set
    main_route = routes.recognize_path('/' + params[:path], { method: request.method })
    if main_route
      schema = JSON.parse(Route.find_by_id(main_route[:name]).responses.first.body_schema)
      render json: GenerateJsonInstanceService.new(schema).execute
    else
      render json: {error: 'Route not found'}, status: :not_found
    end
  end

end
