module Proxy
  class ReportDecorator < Draper::Decorator
    decorates Report

    delegate_all

    def errors_from_request
      errors_for_request_body
    end

    def errors_for_request_body
      json_schema = object.route.request_resource_representation&.json_schema
      body_to_check = object.request_body
      body_is_empty = body_to_check.length.zero?

      if json_schema.nil?
        return [] if body_is_empty
        return [ValidationError.new(category: :body, description: 'Body must be empty')]
      end

      return [ValidationError.new(category: :body, description: 'Body must not be empty')] if body_is_empty

      begin
        errors = JSON::Validator.fully_validate(
          json_schema, body_to_check, json: true
        )
      rescue JSON::Schema::JsonParseError
        return [ValidationError.new(category: :body, description: 'Body is not a valid JSON')]
      end

      return [] if errors.empty?

      [
        ValidationError.new(
          category: :body,
          description: errors.join("\n")
        )
      ]
    end
  end
end