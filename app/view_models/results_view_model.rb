class ResultsViewModel
  def initialize(results)
    @results = results.group_by(&:class)
  end

  def empty?
    @results.empty?
  end

  def size
    @results.values.map(&:count).sum
  end

  def resources
    @results[Resource] || []
  end

  def routes
    @results[Route] || []
  end

  def resource_representations
    @results[ResourceRepresentation] || []
  end

  def resource_attributes
    @results[Attribute] || []
  end

  def responses
    @results[Response] || []
  end

  def headers_size
    @results[Header]&.size || 0
  end

  def response_headers
    (@results[Header] || []).select { |h| h.http_message_type == 'Response' }
  end

  def route_headers
    (@results[Header] || []).select { |h| h.http_message_type == 'Route' }
  end

  def resource_instances
    @results[ResourceInstance] || []
  end

  def api_error_instances
    @results[ApiErrorInstance] || []
  end

  def reports
    @results[Report] || []
  end

  def api_errors
    @results[ApiError] || []
  end

  def validation_errors
    @results[ValidationError] || []
  end

  def query_parameters
    @results[QueryParameter] || []
  end

  def metadata
    @results[Metadatum] || []
  end

  def project
    (@results[Project] || []).first
  end

  def metadatum_instances
    @results[MetadatumInstance] || []
  end

  def mock_profiles
    @results[MockProfile] || []
  end

  def mock_pickers
    @results[MockPicker] || []
  end
end
