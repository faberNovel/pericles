class SearchService
  def initialize(project)
    @project = project
  end

  def search(query)
    [
      search_api_error_instances(query),
      search_api_errors(query),
      search_attributes(query),
      search_headers(query),
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
      search_description(query),
      search_schemes(query),
      search_validation_errors(query)
    ].sum
  end

  def search_api_error_instances(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_api_errors(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_attributes(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_headers(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_metadata(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_mock_pickers(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_mock_profiles(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_project(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_query_parameters(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_reports(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_resource_instances(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_resource_representations(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_resources(query)
    @project.resources.where(
      "name like ?", "%#{query}%"
    ).or(
      @project.resources.where(
        "description like ?", "%#{query}%"
      )
    )
  end

  def search_responses(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_routes(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_description(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_schemes(_query)
    # TODO Clément Villain 8/03/18
    []
  end

  def search_validation_errors(_query)
    # TODO Clément Villain 8/03/18
    []
  end
end
