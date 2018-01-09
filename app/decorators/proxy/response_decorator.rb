module Proxy
  class ResponseDecorator < Draper::Decorator
    delegate_all
    decorates Response

    def errors_from_http_response(http_response)
      errors_for_status(http_response) +
      errors_for_headers(http_response) +
      errors_for_body(http_response)
    end

    def errors_for_status(http_response)
      self.status_code == http_response.status.code ? [] :
      [
        ValidationError.new(
          category: :status_code,
          description: "Status code is #{http_response.status.code} instead of #{self.status_code}"
        )
      ]
    end

    def errors_for_headers(http_response)
      self.headers.map do |h|
         ValidationError.new(
          category: :header,
          description: "#{h.name} is missing from the response headers"
        ) unless http_response.headers.to_h.key? h.name
      end.compact
    end

    def errors_for_body(http_response)
      if json_schema.nil?
        body_is_empty = http_response.body.to_s.length.zero?
        return [] if body_is_empty
        return [ValidationError.new(category: :body, description: 'Body must be empty')]
      end

      errors = JSON::Validator.fully_validate(
        json_schema, http_response.body, json: true
      )

      errors.empty? ? [] :
      [
        ValidationError.new(
          category: :body,
          description: errors.join("\n")
        )
      ]
    end
  end
end