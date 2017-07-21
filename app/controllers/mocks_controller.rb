class MocksController < ApplicationController

  def compute_mock
    routes = Project.find(params[:project_id]).build_route_set
    main_route = routes.recognize_path('/' + params[:path])
    if main_route
      schema = JSON.parse(Route.find_by_id(main_route[:name]).responses.first.body_schema)
      render json: get_json_instance_for_schema(schema)
    else
      render json: {error: 'Route not found'}, status: :not_found
    end
  end

  private

  def get_json_instance_for_schema(schema)
    source = File.open(File.join(Rails.root, 'app', 'assets', 'javascripts', 'json-schema-faker.min.js')).read
    context = ExecJS.compile(source)
    context.eval("jsf(" + schema.to_json + ")");
  end

end
