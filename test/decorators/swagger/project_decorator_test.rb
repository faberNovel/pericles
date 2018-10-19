require 'test_helper'

module Swagger
  class ProjectDecoratorTest < ActiveSupport::TestCase
    setup do
      project = create(:project)
      resource = create(:pokemon, project: project)
      representation = resource.resource_representations.first
      route = create(:route, resource: resource, request_resource_representation: representation)
      create(:response, route: route, resource_representation: representation)
      @decorator = Swagger::ProjectDecorator.new(project.reload)
    end

    test 'generated json is valid according to spec' do
      open_api_json = @decorator.to_swagger
      meta_schema = File.read(Rails.root.join('test', 'decorators', 'swagger', 'open_api_3.0.json_schema'))
      assert JSON::Validator.fully_validate(meta_schema, open_api_json, json: true).empty?
    end
  end
end
