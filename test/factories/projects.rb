FactoryGirl.define do

  sequence :project_title do |n|
    "Project #{n}"
  end

  factory :project do
    title { generate(:project_title) }
    description "That's it !"
    proxy_url nil

    factory :full_project do
      proxy_url 'http://api.xyz/'

      after(:create) do |project, _|
        resource = create(:resource, project: project)
        attribute = create(:attribute, parent_resource: resource, name: 'user', primitive_type: :string)
        resource_representation = create(:resource_representation, resource: resource)
        create(:attributes_resource_representation, parent_resource_representation: resource_representation, is_required: true, resource_attribute: attribute)
        route = create(:route, url: '/users/:id', http_method: 'GET', resource: resource)
        response = create(:response, route: route, root_key: '', is_collection: false, resource_representation: resource_representation)
        create(:header, http_message: response, name: 'X-Special-Header')
      end
    end

    after(:create) do |project, _|
      create(:mock_profile, project: project)
    end
  end
end
