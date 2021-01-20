class Swagger::RouteDecorator < Draper::Decorator
  delegate_all

  def to_swagger(api_gateway_integration)
    {
      tags: [resource.name],
      description: description,
      operationId: swagger_operation_id,
      parameters: parameters,
      responses: responses,
      requestBody: request_body,
      deprecated: deprecated?,
      security: security,
      'x-amazon-apigateway-integration' => x_amazon_apigateway_integration(api_gateway_integration)
    }.select { |_, v| v.present? }
  end

  def swagger_operation_id
    return operation_id if operation_id.present?

    result = http_method.downcase
    url.split('/').map do |part|
      if part.starts_with?(':')
        result += "By#{part[1..-1].capitalize}"
      else
        result += part.capitalize
      end
    end
    result.delete("^a-zA-Z0-9")
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
    query_parameters + path_parameters
  end

  def request_body
    return unless request_resource_representation

    if plain_representation?
      ref = JSONSchema::ResourceRepresentationDecorator.new(
        request_resource_representation, context: context
      ).ref
    else
      ref = "#{context[:base_href]}Request_#{object.id}"
    end

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

  def path_parameters
    path_parameters_names.map do |parameter|
      {
          name: parameter,
          in: 'path',
          required: true,
          schema: {
              type: "string"
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
    path_parameters_names.each do |parameter|
      request_parameters['integration.request.path.' + parameter] = 'method.request.path.' + parameter
    end

    {
      cacheKeyParameters: request_parameters.keys,
      httpMethod: http_method,
      passthroughBehavior: 'when_no_match',
      requestParameters: request_parameters,
      timeoutInMillis: api_gateway_integration.timeout_in_millis,
      type: 'http_proxy',
      uri: api_gateway_integration.uri_prefix + normalized_url(remove_plus_signs: true)
    }
  end

  def path_parameters_names
    parts = url.split('/')
    parameter_parts = parts.select do |part|
      part.starts_with?(':')
    end
    parameter_parts.map do |part|
      if part.ends_with?('+')
        part[1..-2]
      else
        part[1..-1]
      end
    end
  end

  def normalized_url(remove_plus_signs: false)
    path_parameters_names.inject(url) do |url, parameter_name|
      pattern = /:(#{parameter_name}\+?)/
      replacement = remove_plus_signs ? "{#{parameter_name}}" : '{\1}'
      url.gsub(pattern, replacement)
    end
  end

  def uid
    if context[:use_resource_representation_name_as_uid] && plain_representation?
      request_resource_representation.name.tr(' ', '_')
    else
      "Request_#{object.id}"
    end
  end
end
