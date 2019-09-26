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
  end
end
