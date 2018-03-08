class SearchService
  def initialize(project)
    @project = project
  end

  def search(query)
    return [] if query.blank?

    # TODO Clément Villain 15/03/2018
    # Refactor search_* methods using pg_search gem or
    # Postgres Basic Text Matching

    [
      search_api_error_instances(query),
      search_api_errors(query),
      search_attributes(query),
      search_response_headers(query),
      search_request_headers(query),
      search_metadata(query),
      search_mock_pickers(query),
      search_mock_profiles(query),
      search_project(query),
      search_query_parameters(query),
      search_reports(query),
      search_resource_instances(query),
      search_resource_representations(query),
      search_resources(query),
      search_responses(query),
      search_routes(query),
      search_schemes(query),
      search_validation_errors(query)
    ].sum
  end

  def search_api_error_instances(query)
    api_error_instances = ApiErrorInstance.joins(:api_error).where(
      api_errors: { project: @project }
    )

    api_error_instances.where(
      "api_error_instances.name ilike ?", "%#{query}%"
    ).or(
      api_error_instances.where(
        'api_error_instances.body::text ilike ?', "%#{query}%"
      )
    )
  end

  def search_api_errors(query)
    @project.api_errors.where(
      "api_errors.name ilike ?", "%#{query}%"
    )
  end

  def search_attributes(query)
    resource_attributes = Attribute.joins(:parent_resource).where(
      resources: { project: @project }
    )

    resource_attributes.where(
      "attributes.name ilike ?", "%#{query}%"
    ).or(
      resource_attributes.where(
        "attributes.description ilike ?", "%#{query}%"
      )
    )
  end

  def search_response_headers(query)
    headers = Header.joins(response: {route: :resource}).where(
      resources: { project_id: @project.id }
    )

    search_headers(headers, query)
  end

  def search_request_headers(query)
    headers = Header.joins(route: :resource).where(
      resources: { project_id: @project.id }
    )

    search_headers(headers, query)
  end

  def search_headers(headers, query)
    headers.where(
      "headers.name ilike ?", "%#{query}%"
    ).or(
      headers.where(
        "headers.value ilike ?", "%#{query}%"
      )
    )
  end

  def search_metadata(query)
    @project.metadata.where(
      "metadata.name ilike ?", "%#{query}%"
    )
  end

  def search_mock_pickers(query)
    mock_pickers = MockPicker.joins(:mock_profile).where(
      mock_profiles: { project_id: @project.id }
    )

    mock_pickers.where(
      "mock_pickers.body_pattern ilike ?", "%#{query}%"
    ).or(
      mock_pickers.where(
        "mock_pickers.url_pattern ilike ?", "%#{query}%"
      )
    )
  end

  def search_mock_profiles(query)
    @project.mock_profiles.where(
      "mock_profiles.name ilike ?", "%#{query}%"
    )
  end

  def search_project(query)
    if @project.description.include? query
      [@project]
    else
      []
    end
  end

  def search_query_parameters(query)
    query_parameters = QueryParameter.joins(route: :resource).where(
      resources: { project_id: @project.id }
    )

    query_parameters.where(
      "query_parameters.name ilike ?", "%#{query}%"
    ).or(
      query_parameters.where(
        "query_parameters.description ilike ?", "%#{query}%"
      )
    )
  end

  def search_reports(query)
    @project.reports.where(
      response_status_code: query.to_i
    ).or(
      @project.reports.where(
        "reports.response_body ilike ?", "%#{query}%"
      )
    ).or(
      @project.reports.where(
        "reports.request_body ilike ?", "%#{query}%"
      )
    ).or(
      @project.reports.where(
        "reports.request_method ilike ?", "%#{query}%"
      )
    ).or(
      @project.reports.where(
        "reports.url ilike ?", "%#{query}%"
      )
    )
  end

  def search_resource_instances(query)
    resource_instances = ResourceInstance.joins(:resource).where(
      resources: { project_id: @project.id }
    )

    resource_instances.where(
      "resource_instances.name ilike ?", "%#{query}%"
    ).or(
      resource_instances.where(
        'resource_instances.body::text ilike ?', "%#{query}%"
      )
    )
  end

  def search_resource_representations(query)
    @project.resource_representations.where(
      "resource_representations.name ilike ?", "%#{query}%"
    ).or(
      @project.resource_representations.where(
        "resource_representations.description ilike ?", "%#{query}%"
      )
    )
  end

  def search_resources(query)
    @project.resources.where(
      "resources.name ilike ?", "%#{query}%"
    ).or(
      @project.resources.where(
        "resources.description ilike ?", "%#{query}%"
      )
    )
  end

  def search_responses(query)
    @project.responses.where(
      status_code: query.to_i
    ).or(
      @project.responses.where(
        "responses.root_key ilike ?", "%#{query}%"
      )
    )
  end

  def search_routes(query)
    @project.routes.where(
      "routes.description ilike ?", "%#{query}%"
    ).or(
      @project.routes.where(
        "routes.url ilike ?", "%#{query}%"
      )
    )
  end

  def search_schemes(query)
    Scheme.where(
      "schemes.name ilike ?", "%#{query}%"
    ).or(
      Scheme.where(
      "schemes.regexp ilike ?", "%#{query}%"
      )
    )
  end

  def search_validation_errors(query)
    validation_errors = ValidationError.joins(:report).where(
      reports: { project_id: @project.id }
    )

    validation_errors.where(
      "validation_errors.description ilike ?", "%#{query}%"
    )
  end
end
