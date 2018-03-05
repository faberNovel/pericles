class Swagger::RouteDecorator < Draper::Decorator
  delegate_all

  def to_swagger
    {
      tags: [resource.name],
      description: description,
      parameters: parameters,
      responses: responses,
      requestBody: request_body
    }.select { |_, v| !v.blank? }
  end

  def responses
    object.responses.group_by(&:status_code).reduce({}) do |hash, (status, resps)|
      # Note Clément Villain 05/03/18
      # Swagger 3.0.0 does not allow us to use more than one Response
      # object per status code so we take the first one
      response = resps.first
      swager_response = Swagger::ResponseDecorator.new(
        response, context: context
      ).to_swagger

      hash.merge!({status.to_s => swager_response})
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
        in: "query",
        required: !q.is_optional,
        schema: {
          type: q.primitive_type
        }
      }
    end
  end
end