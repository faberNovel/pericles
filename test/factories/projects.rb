FactoryGirl.define do

  sequence :project_title do |n|
    "Project #{n}"
  end

  factory :project do
    title { generate(:project_title) }
    description "That's it !"
    server_url nil

    factory :full_project do
      server_url 'http://api.xyz/'

      after(:create) do |project, _|
        resource = create(:resource, project: project)
        route = create(:route, url: '/users/:id', http_method: 'GET', resource: resource)
        body_schema = '{
          "$schema": "http://json-schema.org/draft-04/schema#",
          "definitions": {},
          "id": "http://example.com/example.json",
          "properties": {
            "user": {
              "default": "hello",
              "description": "An explanation about the purpose of this instance.",
              "examples": [
                "hello"
              ],
              "id": "/properties/user",
              "title": "The user schema.",
              "type": "string"
            }
          },
          "required": ["user"],
          "type": "object"
        }'
        response = create(:response, route: route, body_schema: body_schema)
        create(:header, http_message: response, name: 'X-Special-Header')
      end
    end
  end
end
