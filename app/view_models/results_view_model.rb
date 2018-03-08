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
end