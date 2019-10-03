class Swagger::RouteDecorator < Draper::Decorator
  delegate_all

  def to_swagger(api_gateway_integration)
    {
      tags: [resource.name],
      description: description,
      parameters: parameters,
      responses: responses,
      requestBody: request_body,
      security: security,
      'x-amazon-apigateway-integration' => x_amazon_apigateway_integration(api_gateway_integration)
    }.select { |_, v| v.present? }
  end

  def responses
    object.responses.group_by(&:status_code).reduce({}) do |hash, (status, resps)|
      # Note Clément Villain 05/03/18
      # Swagger 3.0.0 does not allow us to use more than one Response
      # object per status code so we take the first one
      response = resps.first
      swagger_response = Swagger::ResponseDecorator.new(
        response, context: context
      ).to_swagger

      hash.merge!({ status.to_s => swagger_response })
    end
  end

  def parameters
    query_parameters
  end

  def request_body
    return unless request_resource_representation

    ref = JSONSchema::ResourceRepresentationDecorator.new(
      request_resource_representation, context: context
    ).ref

    {
      content: {
        'application/json' => {
          schema: {
            '$ref' => ref
          }
        }
      },
      required: true
    }
  end

  def query_parameters
    request_query_parameters.map do |q|
      {
        name: q.name,
        in: 'query',
        required: !q.is_optional,
        schema: {
          type: q.primitive_type
        }
      }
    end
  end

  def security
    return unless security_scheme

    [{security_scheme.key => []}]
  end

  def x_amazon_apigateway_integration(api_gateway_integration)
    return unless api_gateway_integration

    request_parameters = {}
    path_parameters.each do |parameter|
      request_parameters['integration.request.path.' + parameter] = 'method.request.path.' + parameter
    end

    {
      cacheKeyParameters: request_parameters.keys,
      httpMethod: http_method,
      passthroughBehavior: 'when_no_match',
      requestParameters: request_parameters,
      timeoutInMillis: api_gateway_integration.timeout_in_millis,
      type: 'http_proxy',
      uri: api_gateway_integration.uri_prefix + url
    }
  end

  def path_parameters
    parts = url.split('/')
    parameter_parts = parts.select do |part|
      part.starts_with?(':')
    end
    parameter_parts.map do |part|
      part[1..-1]
    end
  end
end
