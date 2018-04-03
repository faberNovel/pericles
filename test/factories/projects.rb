FactoryBot.define do

  sequence :project_title do |n|
    "Project #{n}"
  end

  factory :project do
    title { generate(:project_title) }
    description "That's it !"

    factory :full_project do
      after(:create) do |project, _|
        resource = create(:resource, project: project)
        attribute = create(:attribute, parent_resource: resource, name: 'user', primitive_type: :string)
        resource_representation = create(:resource_representation, resource: resource)
        create(:attributes_resource_representation, parent_resource_representation: resource_representation, is_required: true, resource_attribute: attribute)
        route = create(:route, url: '/users/:id', http_method: 'GET', resource: resource)
        response = create(:response, route: route, root_key: '', is_collection: false, resource_representation: resource_representation)
        create(:header, http_message: response, name: 'X-Special-Header')
        create(:proxy_configuration, target_base_url: 'http://api.xyz/', project: project)
      end
    end
  end
end
