require 'test_helper'

module Swagger
  class ProjectDecoratorTest < ActiveSupport::TestCase
    setup do
      @project = create(:project)
      @security_scheme = create(:security_scheme, project: @project)
      @resource = create(:pokemon, project: @project)
      @representation = @resource.resource_representations.first
      @route = create(:route, resource: @resource, request_resource_representation: @representation, security_scheme: @security_scheme)
      @response = create(:response, route: @route, resource_representation: @representation)
      @route_with_id = create(:route_with_id, resource: @resource, request_resource_representation: @representation, security_scheme: @security_scheme)
      @response_with_id = create(:response, route: @route_with_id, resource_representation: @representation)
      @api_gateway_integration = create(:api_gateway_integration, project: @project)
      @decorator = Swagger::ProjectDecorator.new(@project.reload)
    end

    test 'generated json is valid according to spec' do
      open_api_json = @decorator.to_swagger
      meta_schema = File.read(Rails.root.join('test', 'decorators', 'swagger', 'open_api_3.0.json_schema'))
      assert JSON::Validator.fully_validate(meta_schema, open_api_json, json: true).empty?
    end

    test 'use resource representation name as uid' do
      assert @decorator.context[:use_resource_representation_name_as_uid]
      assert @decorator.to_swagger.include? '#/components/schemas/DefaultPokemon'

      other_resource = create(:resource, project: @project)
      other_resource.resource_representations.first.update(name: @representation.name)
      refute @decorator.context[:use_resource_representation_name_as_uid]
      refute @decorator.to_swagger.include? '#/components/schemas/DefaultPokemon'
    end

    test 'generated json contains valid security schemes' do
      generated_security_schemes = JSON.parse(@decorator.to_swagger)["components"]["securitySchemes"]
      expected_security_schemes = {
          "theUltimateSecurity" => {
              "type" => "apiKey",
              "name" => "Authorization",
              "in" => "header",
              "x-amazon-apigateway-authtype" => "cognito_user_pools"
          }
      }
      assert_equal generated_security_schemes, expected_security_schemes
    end

    test 'generated json with api gateway integration contains configured title' do
      generated_swagger = JSON.parse(@decorator.to_swagger(true))
      assert_equal generated_swagger['info']['title'], 'api title'
    end

    test 'generated route json contains valid API Gateway Integration structure' do
      generated_x_amazon_apigateway_integration = JSON.parse(@decorator.to_swagger(true))['paths']['/users/:id']['get']['x-amazon-apigateway-integration']
      expected_x_amazon_apigateway_integration = {
        'cacheKeyParameters' => ['integration.request.path.id'],
        'httpMethod' => 'GET',
        'passthroughBehavior' => 'when_no_match',
        'requestParameters' => {
          'integration.request.path.id' => 'method.request.path.id'
        },
        'timeoutInMillis' => '29000',
        'type' => 'http_proxy',
        'uri' => 'prefix/users/:id'
      }
      assert_equal generated_x_amazon_apigateway_integration, expected_x_amazon_apigateway_integration
    end
  end
end
