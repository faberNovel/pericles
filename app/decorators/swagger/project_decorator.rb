module Swagger
  class ProjectDecorator < Draper::Decorator
    delegate_all

    def to_swagger
      {
        openapi: '3.0.0',
        info: {
          description: description,
          title: title,
          version: '1.0.0'
        },
        servers: servers,
        tags: tags,
        paths: paths,
        components: components
      }.deep_stringify_keys.to_json
    end

    def components
      {
        schemas: resource_representation_definitions.merge(response_definitions),
        securitySchemes: security_schemes_representations
      }
    end

    def resource_representation_definitions
      resource_representations.reduce({}) do |hash, r|
        representation = JSONSchema::ResourceRepresentationDecorator.new(
          r, context: context
        )

        json_schema = representation.json_schema_without_definitions
        delete_siblings_values_if_ref(json_schema)
        hash.merge!(
          {
            representation.uid => json_schema
          }
        )
      end
    end

    def response_definitions
      responses.select(&:json_schema).reduce({}) do |hash, r|
        response = JSONSchema::ResponseDecorator.new(
          r, context: context
        )
        uid = Swagger::ResponseDecorator.new(r, context: context).uid

        json_schema = response.json_schema.except(:definitions, :$schema)
        delete_siblings_values_if_ref(json_schema)
        hash.merge!(
          {
            uid => json_schema
          }
        )
      end
    end

    def servers
      if proxy_configuration
        [
          {
            url: proxy_configuration.target_base_url,
            description: 'Proxied server'
          }
        ]
      else
        []
      end
    end

    def tags
      routes.map(&:resource).uniq.map do |r|
        {
          name: r.name,
          description: r.description
        }.select { |_, v| v.present? }
      end
    end

    def paths
      routes_by_url = routes.group_by do |r|
        r.url.starts_with?('/') ? r.url : "/#{r.url}"
      end

      routes_by_url.reduce({}) do |hash, (url, routes)|
        routes_by_method = routes.reduce({}) do |h, r|
          r = Swagger::RouteDecorator.new(r, context: context)

          h.merge!(
            {
              r.http_method.to_s.downcase => r.to_swagger
            }
          )
        end

        hash.merge!(
          {
            url => routes_by_method
          }
        )
      end
    end

    def context
      {
        base_href: '#/components/schemas/',
        use_nullable: true,
        use_resource_representation_name_as_uid: resource_representations.group(:name).having('COUNT(*) > 1').empty?
      }.merge(super)
    end

    private

    def delete_siblings_values_if_ref(json_schema)
      # TODO: Clement Villain 30/10/2018
      # Open API v3 emits a warning if we have siblings value and a $ref
      # We should look how to handle $ref + nullable

      properties = json_schema[:properties] || json_schema.dig(:items, :properties)
      return if properties.nil?

      objects = properties.values + properties.values.map { |v| v.dig(:items) }.compact
      objects = (objects + objects.map { |v| v.dig(:anyOf) }).compact.flatten
      objects.select { |o| o[:$ref] }.each do |object|
        (object.keys - [:$ref]).each { |key| object.delete(key) }
      end
    end

    def security_schemes_representations
      security_schemes_json = {}

      security_schemes.each do |security_scheme|
        security_schemes_json[security_scheme.key] = {
          type: security_scheme.security_scheme_type,
          name: security_scheme.name,
          in: security_scheme.security_scheme_in
        }.merge(JSON.parse(security_scheme.parameters))
      end

      security_schemes_json
    end
  end
end
